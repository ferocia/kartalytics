import React, {useEffect, useRef} from 'react';
import {css} from '@emotion/react';
import {debounce} from 'lodash';
import Chart from './chart';
import * as colors from 'styles/colors';
import type {Entities} from 'types';

type Props = {
  race: Entities.RaceChart;
};

export default function RaceChart(props: Props) {
  const chart = useRef<Chart>();
  const chartEl = useRef<SVGSVGElement>(null);

  useEffect(() => {
    if (chartEl.current == null) {
      throw Error('chartEl is not assigned');
    }

    chart.current = new Chart(chartEl.current, props.race);

    const handleWindowResize = () => chart.current?.handleResize();
    const debouncedHandleWindowResize = debounce(handleWindowResize, 150);
    window.addEventListener('resize', debouncedHandleWindowResize);

    return () => {
      debouncedHandleWindowResize.cancel();
      window.removeEventListener('resize', debouncedHandleWindowResize);
    };
  }, []);

  useEffect(() => {
    chart.current?.handleUpdate(props.race);
  }, [props.race]);

  return (
    <div css={styles.root}>
      <svg ref={chartEl} />
    </div>
  );
}

const styles = {
  root: css`
    background: ${colors.black};
    border-radius: 0.3rem;
    border: 0.1rem solid rgba(0, 0, 0, 0.5);
    display: flex;
    flex: 1;
    margin-top: 2rem;

    svg {
      flex: 1;
    }

    .axis {
      text {
        fill: rgba(255, 255, 255, 0.6);
        font-size: 1.6rem;
      }

      line,
      path {
        stroke: rgba(255, 255, 255, 0.1);
      }
    }

    .player-name {
      font-size: 1.6rem;
      font-weight: bold;
    }

    .player-time {
      font-size: 1.6rem;
    }
  `,
};
