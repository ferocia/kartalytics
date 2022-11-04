import React, {useEffect, useState} from 'react';
import {Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip} from 'chart.js';
import {Bar} from 'react-chartjs-2';
import type {Entities} from 'types';

type Props = {
  players: Entities.CourseRecord[];
};

export default function PlayerTopTimesBarChart({players}: Props) {
  const playerNames: string[] = players.map(({player_name}) => player_name);
  const times: number[] = players.map(({race_time}) => race_time);
  const [options, setOptions] = useState<any>(null);
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    setOptions({
      responsive: true,
      plugins: {
        legend: {
          display: false,
        },
      },
      scales: {
        y: {
          min: Math.floor(times[0] - 2),
          max: Math.floor(times[times.length - 1] + 2),
          stepSize: 1,
        },
        x: {},
      },
    });

    setData({
      labels: playerNames,
      datasets: [
        {
          data: times,
          backgroundColor: 'rgba(25, 191, 241, 0.5 )',
        },
      ],
    });

    ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip);
  }, [players]);

  if (options == null || data == null) return null;

  return <Bar options={options} data={data} />;
}
