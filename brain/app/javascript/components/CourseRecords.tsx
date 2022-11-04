import React from 'react';
import {css} from '@emotion/react';
import {formatTime} from 'lib/helpers';
import type {Entities} from 'types';

type Props = {
  players: Required<Entities.Event>['race']['players'];
};

export default function CourseRecords({players}: Props) {
  return (
    <div css={styles.root}>
      {players
        .filter(player => player.pb_set || player.course_record_set)
        .sort((a, b) => ((a.race_time ?? 0) > (b.race_time ?? 0) ? 1 : -1))
        .map((player, index) => (
          <Player key={index} player={player} />
        ))}
    </div>
  );
}

function Player({player}: {player: Props['players'][number]}) {
  const label = player.course_record_set ? 'New course record!' : `New PB for ${player.label}!`;
  const time = formatTime(player.race_time);
  const delta = formatTime(player.course_record_set ? player.course_record_delta : player.pb_delta);

  return (
    <span
      css={css`
        ${styles.record};
        color: ${player.color};
      `}
    >
      {label} {time} {delta && `(${delta})`}
    </span>
  );
}

const styles = {
  root: css`
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    transform: translateY(-50%);
    font-family: SuperMario;
    font-size: 100rem;
    font-size: 5.5vw;
    text-align: center;
    text-transform: uppercase;
    pointer-events: none;
    z-index: 999;
    animation: color-change 1s alternate infinite linear;
    -webkit-text-stroke: 0.01em rgba(255, 255, 255, 0.2);

    @keyframes color-change {
      from {
        opacity: 0.4;
      }

      to {
        opacity: 1;
      }
    }
  `,

  record: css`
    display: block;
  `,
};
