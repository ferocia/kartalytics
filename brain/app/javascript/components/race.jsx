import React from 'react'
import Chart from './chart'

export default class Race extends React.Component {
  componentDidMount() {
    this.chart = new Chart(this.chartEl, this.props.race);
  }

  componentDidUpdate() {
    this.chart.handleUpdate(this.props.race);
  }

  render() {
    return(
      <div className="race_wrapper">
        <svg ref={chartEl => this.chartEl = chartEl}></svg>
      </div>
    );
  }
}
