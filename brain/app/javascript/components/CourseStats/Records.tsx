import React from 'react';
import {css} from '@emotion/react';
import * as colors from 'styles/colors';

type Props = {
  records: Array<{
    player_name: string;
    value: string | number;
  }>;
};

export default function Records({records}: Props) {
  return (
    <ol css={styles.list}>
      {records.map((record, index) => (
        <li css={styles.listItem} key={index}>
          <span css={styles.playerName}>{record.player_name}</span>
          <span>{record.value}</span>
        </li>
      ))}
    </ol>
  );
}

const styles = {
  list: css`
    counter-reset: item;
  `,

  listItem: css`
    align-items: center;
    background: ${colors.black};
    border-radius: 0.25rem;
    counter-increment: item;
    display: flex;
    font-size: 1.6vw;
    margin-top: 1.25em;
    padding: 1em;

    &::before {
      content: counter(item);
      font-family: SuperMario;
      font-size: 1.5em;
      margin-right: 1em;
    }
  `,

  playerName: css`
    flex: 1;
  `,
};
