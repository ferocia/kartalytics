import React from 'react';
import {css} from '@emotion/react';
import * as colors from 'styles/colors';
import type {Entities} from 'types';

type Props = {
  rivalResults: Entities.ComplexPlayer['rival_results'];
};

export default function RivalTable({rivalResults}: Props) {
  return (
    <div css={styles.root}>
      <div css={styles.tbl}>
        {rivalResults.map((rival, id) => (
          <div key={id} css={styles.row}>
            <span css={[styles.cell, styles.cellRivalName]}>{rival.name}</span>
            {rival.results.map((result, id) => (
              <span key={id} css={[styles.cell, result === 1 ? styles.colorGreen : styles.colorRed]}>
                {result === 1 ? 'W' : 'L'}
              </span>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}

const styles = {
  root: css`
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 0.6rem;
    padding: 3rem;
    min-width: 760px;
  `,

  tbl: css`
    display: flex;
    flex-direction: column;
    min-width: 200px;
    font-size: 1.8em;
  `,

  row: css`
    display: flex;
  `,

  cell: css`
    text-align: center;
    width: 2.5rem;
    padding-top: 1rem;
  `,

  cellRivalName: css`
    text-align: left;
    width: 10rem;
  `,

  colorGreen: css`
    color: ${colors.green};
  `,

  colorRed: css`
    color: ${colors.red};
  `,
};
