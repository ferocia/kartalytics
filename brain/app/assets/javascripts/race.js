var WIDTH = 1000;
var HEIGHT = 500;
var MARGINS = {
  top: 20,
  right: 180,
  bottom: 40,
  left: 50
};
var CHART_WIDTH = WIDTH - MARGINS.left - MARGINS.right;
var CHART_HEIGHT = HEIGHT - MARGINS.top - MARGINS.bottom;
var PLAYER_KEY_OFFSET = 5;
var TRANSITION_DURATION = 300;
var UPDATE_TIMEOUT = 500;

class Chart {
  constructor(raceId, data) {
    this.raceId = raceId;
    this.data = data;

    this.setupChart();
    this.next();
  }

  next() {
    if (this.data.status === 'finished') {
      this.finish();
    } else {
      this.update();
    }
  }

  setupChart() {
    this.svg = d3.select(`.chart[data-id="${this.raceId}"]`);

    this.data.players.forEach(this.setupPlayerFilter.bind(this));

    this.chartGroup = this.svg
      .append('g')
      .attr('transform', 'translate(' + MARGINS.left + ', ' + MARGINS.top + ')');

    this.yScale = d3.scaleLinear().range([CHART_HEIGHT, 0]).domain([12,1]);
    this.xScale = d3.scaleTime().range([0, CHART_WIDTH]).domain([this.startTime, this.endTime]);

    this.yAxis = d3.axisLeft().scale(this.yScale);

    this.xAxis = d3.axisBottom()
      .ticks(d3.timeSecond.every(10))
      .tickFormat(t => Math.ceil((t - this.startTime) / 1000) + 's')
      .scale(this.xScale);

    this.xAxisGroup = this.chartGroup
      .append('g')
      .attr('class', 'axis axis-x')
      .attr('transform', 'translate(0, ' + CHART_HEIGHT + ')')
      .call(this.xAxis);

    this.yAxisGroup = this.chartGroup
      .append('g')
      .attr('class', 'axis axis-y')
      .call(this.yAxis);

    this.playerKeyGroup = this.chartGroup
      .append('g')
      .attr('class', 'player-key-group')
      .attr('transform', 'translate(' + CHART_WIDTH + ', 0)');

    this.linesGroup = this.chartGroup.append('g').attr('class', 'players');
    this.itemsGroup = this.chartGroup.append('g').attr('class', 'items');

    this.line = d3.line()
      .curve(d3.curveMonotoneX)
      .x(d => this.xScale(new Date(d.timestamp)))
      .y(d => this.yScale(d.position));

    this.playerKeys = this.data.players.map(this.renderPlayerKey.bind(this));
    this.paths = this.data.players.map(this.renderPlayerPath.bind(this));

    this.renderPlayerItems();
    this.renderPlayerItems(); // Needs to be called twice
  }

  setupPlayerFilter(player) {
    var filter = this.svg
      .append('defs')
      .append('filter')
      .attr('id', `stroke-${player.player}`)

    filter
      .append('feFlood')
      .attr('flood-color', player.color)
      .attr('result', 'strokeColor');

    filter
      .append('feMorphology')
      .attr('in', 'SourceAlpha')
      .attr('operator', 'dilate')
      .attr('radius', '1');

    filter
      .append('feComposite')
      .attr('in', 'strokeColor')
      .attr('operator', 'in')
      .attr('result', 'outsideStroke');

    filter
      .append('feMorphology')
      .attr('in', 'sourceAlpha')
      .attr('operator', 'erode')
      .attr('radius', '1');

    filter
      .append('feComposite')
      .attr('in', 'SourceGraphic')
      .attr('operator', 'in')
      .attr('result', 'fill');

    var merge = filter.append('feMerge');

    merge.append('feMergeNode').attr('in', 'outsideStroke');
    merge.append('feMergeNode').attr('in', 'fill');
  }

  renderPlayerPath(player, index) {
    return this.linesGroup
      .append('path')
      .attr('class', 'player')
      .attr('d', this.line(player.data))
      .attr('stroke', player.color)
      .attr('stroke-width', 2)
      .attr('fill', 'none');
  }

  renderPlayerKey(player) {
    var key = this.playerKeyGroup
      .append('text')
      .attr('transform', 'translate(10, ' + PLAYER_KEY_OFFSET + ')')
      .attr('dy', this.yScale(player.data[player.data.length - 1].position))
      .attr('fill', player.color);

    key.append('tspan').attr('class', 'player-name').text(player.label);
    key.append('tspan').attr('class', 'player-time').attr('dx', 10);

    return key;
  }

  renderPlayerItems() {
    this.playerItems = this.itemsGroup
      .selectAll('.player-items')
      .data(this.data.players, d => d.player);

    this.playerItems.enter().append('g').attr('class', 'player-items');
    this.playerItems.exit().remove();

    this.items = this.playerItems
      .selectAll('.item')
      .data(player => {
        return player.data
          .filter(d => d.item != null)
          .map(p => Object.assign(p, {player: player.player}))
      }, d => d.timestamp);

    this.items
      .transition(this.transition)
      .attr('x', point => this.xScale(new Date(point.timestamp)) - 10)
      .attr('y', point => this.yScale(point.position) - 10);

    this.items
      .enter()
      .append('image')
      .attr('class', 'item')
      .attr('width', 0)
      .attr('height', 0)
      .attr('filter', point => `url(#stroke-${point.player})`)
      .attr('xlink:href', point => itemMapping[point.item])
      .attr('x', point => this.xScale(new Date(point.timestamp)) - 10)
      .attr('y', point => this.yScale(point.position) - 10)
      .attr('transform', 'translate(10, 10)')
      .transition(this.transition)
      .attr('transform', 'translate(0, 0)')
      .attr('width', 20)
      .attr('height', 20);

    this.items.exit().remove();
  }

  get startTime() {
    return Math.min.apply(Math, this.data.players.map(p => new Date(p.data[0].timestamp)));
  }

  get endTime() {
    return Math.max.apply(Math, this.data.players.map(p => new Date(p.data[p.data.length - 1].timestamp)));
  }

  get transition() {
    return d3.transition().duration(TRANSITION_DURATION).ease(d3.easeExpInOut);
  }

  update() {
    setTimeout(this.fetchUpdate.bind(this), UPDATE_TIMEOUT);
  }

  fetchUpdate() {
    $.getJSON(`/api/kartalytics/race_update/${this.raceId}`, this.handleUpdate.bind(this));
  }

  handleUpdate(data) {
    this.data = data;

    this.updateScale();
    this.updatePlayers();
    this.renderPlayerItems();

    this.next();
  }

  updateScale() {
    var startTime = this.startTime;
    var endTime = this.endTime;
    var delta = endTime - startTime;

    if (delta < 20 * 1000) {
      this.xAxis.ticks(d3.timeSecond.every(1));
    } else if (delta < 60 * 1000) {
      this.xAxis.ticks(d3.timeSecond.every(5));
    } else if (delta < 120 * 1000) {
      this.xAxis.ticks(d3.timeSecond.every(10));
    } else {
      this.xAxis.ticks(d3.timeSecond.every(30));
    }

    this.xScale.domain([startTime, endTime]);
    this.xAxisGroup.transition(this.transition).call(this.xAxis);
  }

  updatePlayers() {
    this.playerKeys.forEach(this.updatePlayerKey.bind(this));
    this.paths.forEach(this.updatePlayerPath.bind(this));
  }

  updatePlayerKey(playerKey, index) {
    var player = this.data.players[index];
    var latestPosition = player.data[player.data.length - 1].position;
    playerKey.transition(this.transition).attr('dy', this.yScale(latestPosition));
  }

  updatePlayerPath(path, index) {
    var player = this.data.players[index];
    var line = this.line;

    var next = this.line(player.data);
    var previous = padPath(path.attr('d'), next);

    path
      .attr('d', previous)
      .transition(this.transition)
      .attr('d', next);
  }

  updatePlayerFinishTime() {
    this.playerKeys.forEach((key, index) => {
      var player = this.data.players[index];

      key
        .select('.player-time')
        .text(player.finishedAt);
    });
  }

  finish() {
    this.updatePlayerFinishTime();
  }
}

// Fill out the old path with duplicate end points to match the new path
// which makes the path transition much nicer
function padPath(previous, next) {
  var previousArray = previous.split(/[A-Z]/);
  var nextArray = next.split(/[A-Z]/);

  if (previousArray.length < nextArray.length) {
    var last = previousArray[previousArray.length - 1];
    nextArray.slice(previousArray.length).forEach(() => {
      var lastParts = last.split(',').filter(p => p != null);
      var component = `${lastParts[lastParts.length - 2]},${lastParts[lastParts.length - 1]}`;
      previous += `C${[component, component, component].join(',')}`;
    });
  }

  return previous;
}

window.Chart = Chart;
