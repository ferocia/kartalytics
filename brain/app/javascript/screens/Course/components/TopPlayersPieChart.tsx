import React from 'react';
import {Chart as ChartJS, ArcElement, Tooltip} from 'chart.js';
import {Pie} from 'react-chartjs-2';
import type {Entities} from 'types';

ChartJS.register(ArcElement, Tooltip);

type Props = {
  players: Entities.ComplexCourse['top_players'];
};

export default function TopPlayersPieChart({players}: Props) {
  const playerNames: string[] = players.map(({player_name}) => player_name);
  const ratios: number[] = players.map(({ratio}) => Math.round(ratio * 100));

  const options = {
    responsive: true,
    plugins: {
      legend: {
        display: false,
      },
    },
  };

  const data = {
    labels: playerNames,
    datasets: [
      {
        data: ratios,
        backgroundColor: [
          'rgba(93, 251, 60, 0.2)',
          'rgba(25, 191, 241, 0.2)',
          'rgba(254, 207, 0, 0.2)',
          'rgba(224, 38, 67, 0.2)',
        ],
        borderColor: ['rgba(93, 251, 60, 1)', 'rgba(25, 191, 241, 1)', 'rgba(254, 207, 0, 1)', 'rgba(224, 38, 67, 1)'],
        borderWidth: 1,
      },
    ],
  };

  if (options == null || data == null) return null;

  return <Pie data={data} options={options} />;
}
