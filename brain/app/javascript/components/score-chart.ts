// @ts-nocheck
/* eslint-disable no-var */

import * as d3 from 'd3';
import cloneDeep from 'lodash/cloneDeep';
import type {Entities} from 'types';

var MARGINS = {
  top: 6,
  right: 6,
  bottom: 22,
  left: 30,
};

type Data = {
  leaderboard: Array<
    Entities.MatchLeaderboard[number] & {
      relative_race_scores?: number[];
    }
  >;
};

export default class Chart {
  el: SVGSVGElement;
  data: Data;

  constructor(el: SVGSVGElement, data: Data) {
    this.el = el;
    this.data = this.calculateRelativeScores(cloneDeep(data));
    this.setupChart();
  }

  // This should probably be calculated on the server, but am not familiar
  // enough with that part yet...
  calculateRelativeScores(data: Data) {
    const leaderboard = data.leaderboard
    const firstPlayer = leaderboard[0]
    if (!firstPlayer)
      return data

    const totalRaces = firstPlayer.cumulative_race_scores.length

    for (let j = 0; j < leaderboard.length; j++) {
      leaderboard[j].relative_race_scores = [];
    }

    for (let i = 0; i < totalRaces; i++) {
      const absoluteScores = leaderboard.map(player => player.cumulative_race_scores[i])
      const midpoint = absoluteScores.reduce((x, y) => x + y) / absoluteScores.length
      const relativeScores = absoluteScores.map(score => score - midpoint)

      for (let j = 0; j < relativeScores.length; j++) {
        leaderboard[j].relative_race_scores.push(relativeScores[j])
      }
    }

    return data;
  }

  setupChart() {
    this.resetChart();

    this.chartWidth = this.el.clientWidth - MARGINS.left - MARGINS.right;
    this.chartHeight = this.el.clientHeight - MARGINS.top - MARGINS.bottom;

    // Assume at least 6 races to reduce graph rescales
    const maxTicks = d3.max([this.racesCount - 1, 6]);

    const axisFormat = d3.format('.0f');
    const yAxisTickValues = [this.lowestScore, (this.lowestScore + this.highestScore) / 2, this.highestScore];
    const xAxisTickValues = [...Array(maxTicks + 1).keys()].slice(1);

    this.chartGroup = d3
      .select(this.el)
      .append('g')
      .attr('transform', `translate(${MARGINS.left}, ${MARGINS.top})`);

    this.yScale = d3
      .scaleLinear()
      .range([this.chartHeight, 0])
      .domain([this.lowestScore, this.highestScore]);
    this.xScale = d3
      .scaleLinear()
      .range([0, this.chartWidth])
      .domain([0, maxTicks])

    this.yAxis = d3
      .axisLeft()
      .tickValues(yAxisTickValues)
      .tickFormat(axisFormat)
      .scale(this.yScale);
    this.xAxis = d3
      .axisBottom()
      .tickValues(xAxisTickValues)
      .tickFormat(axisFormat)
      .scale(this.xScale);

    this.xAxisGroup = this.chartGroup
      .append('g')
      .attr('class', 'axis axis-x')
      .attr('transform', `translate(0, ${this.chartHeight})`)
      .call(this.xAxis);

    this.yAxisGroup = this.chartGroup
      .append('g')
      .attr('class', 'axis axis-y')
      .call(this.yAxis);

    this.linesGroup = this.chartGroup.append('g').attr('class', 'players');

    this.line = d3
      .line()
      .x((d, i) => this.xScale(i))
      .y(d => this.yScale(d));

    this.data.leaderboard.map(this.renderPlayerPath.bind(this));
  }

  renderPlayerPath(player: Data['leaderboard'][number]) {
    return this.linesGroup
      .append('path')
      .attr('class', 'player')
      .attr('d', this.line(player.relative_race_scores))
      .attr('stroke', player.color)
      .attr('stroke-width', 3)
      .attr('fill', 'none');
  }

  get lowestScore() {
    return this.data.leaderboard.reduce((score, p) => Math.min(...p.relative_race_scores, score), Infinity);
  }

  get highestScore() {
    return this.data.leaderboard.reduce((score, p) => Math.max(...p.relative_race_scores, score), 0);
  }

  get racesCount() {
    return this.data.leaderboard[0].relative_race_scores.length;
  }

  resetChart() {
    d3.select(this.el)
      .selectAll('*')
      .remove();
  }

  handleUpdate(data: Data) {
    this.data = this.calculateRelativeScores(cloneDeep(data));
    this.setupChart();
  }

  handleResize() {
    this.setupChart();
  }
}
