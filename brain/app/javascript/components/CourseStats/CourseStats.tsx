import React from 'react';
import {css} from '@emotion/react';
import pluralize from 'pluralize';
import {formatTime} from 'lib/helpers';
import Section from './Section';
import type {Entities} from 'types';

type CourseProps = Required<Required<Entities.Event>['race']>;

type Props = {
  topRecords: CourseProps['course_top_records'];
  topPlayers: CourseProps['course_top_players'];
  showPercentage?: boolean;
};

export default function CourseStats({topRecords, topPlayers, showPercentage = true}: Props) {
  return (
    <div css={styles.root}>
      <Section
        title="Top Times"
        records={topRecords.map(({player_name, race_time}) => ({player_name, value: formatTime(race_time)}))}
      />
      <Section
        title="Top Players"
        titleColor="blue"
        records={topPlayers.map(({player_name, wins, games, ratio}) => ({
          player_name,
          value: `${wins} ${pluralize('win', wins)} / ${games} ${pluralize('game', games)} ${
            showPercentage ? `(${Math.round(ratio * 100)}%)` : ''
          }`,
        }))}
      />
    </div>
  );
}

const styles = {
  root: css`
    display: flex;
    justify-content: space-between;
    margin-top: 2rem;
  `,
};
