import React from 'react';
import {css} from '@emotion/react';
import Race from 'components/Race';
import type {Entities} from 'types';

type Props = {
  races: Entities.ComplexMatch['races'];
};

export default function Races({races}: Props) {
  return (
    <div css={styles.root}>
      {races.map((race, index) => (
        <Race key={race.id} race={race} index={index} />
      ))}
    </div>
  );
}

const styles = {
  root: css`
    display: flex;
    flex-direction: column-reverse;
    flex: 1;
    margin-left: 34rem;
  `,
};
