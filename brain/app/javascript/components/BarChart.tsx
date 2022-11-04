import * as d3 from 'd3';
import React, {useRef, useEffect} from 'react';
import {css} from '@emotion/react';
import * as colors from 'styles/colors';

type Props = {
  width: number;
  height: number;
  data: number[];
};

export default function BarChart({width, height, data}: Props) {
  const ref = useRef<SVGSVGElement>(null);

  useEffect(() => {
    draw();
  }, [data]);

  function draw() {
    const barWidth = width / data.length;

    const yScale = d3
      .scaleLinear()
      .domain([0, d3.max(data, d => d) as number])
      .range([height, 0]);

    const chart = d3.select(ref.current).attr('width', width).attr('height', height);

    chart.append('g').attr('class', 'y axis').call(d3.axisLeft(yScale));

    const groups = chart
      .selectAll('.bar')
      .data(data)
      .enter()
      .append('g')
      .attr('transform', (d, i) => `translate(${i * barWidth}, 0)`);

    groups
      .append('rect')
      .attr('y', d => yScale(d))
      .attr('height', d => height - yScale(d))
      .attr('width', barWidth - 1);

    groups
      .append('text')
      .attr('y', d => yScale(d) + 20)
      .attr('x', barWidth / 2 + 6)
      .attr('height', d => height - yScale(d))
      .attr('width', barWidth - 1)
      .text(d => d);
  }

  return (
    <div css={styles.root}>
      <svg ref={ref}></svg>
    </div>
  );
}

const styles = {
  root: css`
    display: flex;
    flex: 1;
    margin-top: 2rem;

    .axis path,
    .axis line {
      fill: none;
      stroke: ${colors.black};
    }

    rect {
      fill: ${colors.orange};
    }

    text {
      fill: ${colors.black};
      font: 12px sans-serif;
      text-anchor: end;
    }
  `,
};
