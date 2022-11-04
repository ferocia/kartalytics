// @ts-nocheck
/* eslint-disable no-var */

import * as d3 from 'd3';
import cloneDeep from 'lodash/cloneDeep';
import {formatTime} from 'lib/helpers';
import type {Entities} from 'types';

var WIDTH = 1000;
var HEIGHT = 560;
var MARGINS = {
  top: 50,
  right: 180,
  bottom: 20,
  left: 60,
};
var CHART_WIDTH = WIDTH - MARGINS.left - MARGINS.right;
var CHART_HEIGHT = HEIGHT - MARGINS.top - MARGINS.bottom;
var PLAYER_KEY_OFFSET = 5;
var TRANSITION_DURATION = 300;
var UPDATE_TIMEOUT = 500;

type Data = Entities.RaceChart;
type Player = Data['players'][number];

export default class Chart {
  el: SVGSVGElement;
  data: Data;

  constructor(el: SVGSVGElement, data: Data) {
    this.el = el;
    this.data = cloneDeep(data);

    this.setupChart();
  }

  setupChart() {
    this.svg = d3.select(this.el);
    const xScale = this.el.clientWidth / WIDTH;
    const yScale = this.el.clientHeight / HEIGHT;
    const scale = Math.min(xScale, yScale);

    this.data.players.forEach(this.setupPlayerFilter.bind(this));

    this.chartGroup = this.svg
      .append('g')
      .attr('transform', `translate(${MARGINS.left}, ${MARGINS.top}) scale(${scale})`);

    this.yScale = d3
      .scaleLinear()
      .range([CHART_HEIGHT, 0])
      .domain([12, 1]);
    this.xScale = d3
      .scaleTime()
      .range([0, CHART_WIDTH])
      .domain([this.startTime, this.endTime]);

    this.yAxis = d3.axisLeft().scale(this.yScale);

    this.xAxis = d3
      .axisBottom()
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

    this.line = d3
      .line()
      .curve(d3.curveMonotoneX)
      .x(d => this.xScale(new Date(d.timestamp)))
      .y(d => this.yScale(d.position));

    this.playerKeys = this.data.players.map(this.renderPlayerKey.bind(this));
    this.paths = this.data.players.map(this.renderPlayerPath.bind(this));

    this.renderPlayerItems();
  }

  setupPlayerFilter(player: Player) {
    var filter = this.svg
      .append('defs')
      .append('filter')
      .attr('id', `stroke-${player.player}`);

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

  renderPlayerPath(player: Player, index: number) {
    if (player.data.length === 0) return;

    return this.linesGroup
      .append('path')
      .attr('class', 'player')
      .attr('d', this.line(player.data))
      .attr('stroke', player.color)
      .attr('stroke-width', 2)
      .attr('fill', 'none');
  }

  renderPlayerKey(player: Player) {
    if (player.data.length === 0) {
      return;
    }
    var key = this.playerKeyGroup
      .append('text')
      .attr('transform', 'translate(10, ' + PLAYER_KEY_OFFSET + ')')
      .attr('dy', this.yScale(player.data[player.data.length - 1].position))
      .attr('fill', player.color);

    key
      .append('tspan')
      .attr('class', 'player-name')
      .text(player.label);
    key
      .append('tspan')
      .attr('class', 'player-time')
      .attr('dx', 10)
      .text(player.delta || formatTime(player.race_time));

    return key;
  }

  renderPlayerItems() {
    this.playerItems = this.itemsGroup.selectAll('.player-items').data(this.data.players, d => d.player);

    this.playerItems
      .enter()
      .append('g')
      .attr('class', 'player-items');
    this.playerItems.exit().remove();

    this.items = this.playerItems.selectAll('.item').data(
      player => {
        return player.data.filter(d => d.item != null).map(p => Object.assign(p, {player: player.player}));
      },
      d => d.timestamp
    );

    this.items
      .transition(this.transition)
      .attr('x', point => this.xScale(new Date(point.timestamp)) - 10)
      .attr('y', point => this.yScale(point.position) - 10);

    // safari doesn't like the url filter 💩
    const isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);

    this.items
      .enter()
      .append('image')
      .attr('class', 'item')
      .attr('width', 0)
      .attr('height', 0)
      .attr('filter', point => isSafari ? null : `url(#stroke-${point.player})`)
      .attr('xlink:href', point => require(`images/items/${point.item}.png`))
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
    var firstPoints = this.data.players.map(p => p.data[0]).filter(Boolean);
    return Math.min(...firstPoints.map(p => new Date(p.timestamp)));
  }

  get endTime() {
    var lastPoints = this.data.players.map(p => p.data[p.data.length - 1]).filter(Boolean);
    return Math.max(...lastPoints.map(p => new Date(p.timestamp)));
  }

  get transition() {
    return d3
      .transition()
      .duration(TRANSITION_DURATION)
      .ease(d3.easeExpInOut);
  }

  // update() {
  //   setTimeout(this.fetchUpdate.bind(this), UPDATE_TIMEOUT);
  // }

  // fetchUpdate() {
  //   $.getJSON(`/api/kartalytics/race_update/${this.raceId}`, this.handleUpdate.bind(this));
  // }

  handleUpdate(data: Data) {
    this.data = cloneDeep(data);

    this.updateScale();
    this.updatePlayers();
    this.renderPlayerItems();
  }

  handleResize() {
    d3.select(this.el)
      .selectAll('*')
      .remove();
    this.setupChart();
    this.renderPlayerItems();
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

    if (player.data.length === 0) {
      return;
    }

    if (playerKey == null) {
      this.playerKeys[index] = playerKey = this.renderPlayerKey(player);
    }

    var latestPosition = player.data[player.data.length - 1].position;
    playerKey.transition(this.transition).attr('dy', this.yScale(latestPosition));
    playerKey.select('.player-name').text(player.label);
    playerKey.select('.player-time').text(player.delta || formatTime(player.race_time));
  }

  updatePlayerPath(path, index) {
    var player = this.data.players[index];
    var line = this.line;

    if (player.data.length === 0) {
      return;
    }

    if (path == null) {
      this.paths[index] = path = this.renderPlayerPath(player);
    }

    var next = this.line(player.data);
    var previous = padPath(path.attr('d'), next);

    path
      .attr('d', previous)
      .transition(this.transition)
      .attr('d', next);
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
