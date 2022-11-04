import React from 'react';
import {css} from '@emotion/react';
import * as colors from 'styles/colors';
import type {Entities} from 'types';

type Props = Entities.Player & {
  position: number;
};

export default function Player({image_url, name, position}: Props) {
  return (
    <div css={[styles.root, podiumStyles(position)]}>
      {position === 1 && <span css={styles.crown}>👑</span>}
      <img css={styles.image} src={image_url} />
      <span css={styles.label}>{name}</span>
      <span css={styles.position}>#{position}</span>
    </div>
  );
}

function podiumStyles(position: number) {
  switch (position) {
    case 1:
      return css`
        background-color: ${colors.gold};
        color: #191922;
      `;
    case 2:
      return css`
        background-color: ${colors.silver};
        color: #191922;
      `;
    case 3:
      return css`
        background-color: ${colors.bronze};
        color: #191922;
      `;
  }
}

const styles = {
  root: css`
    align-items: center;
    background-color: #141414;
    border-bottom: 0.3rem solid rgba(0, 0, 0, 0.3);
    border-radius: 0.3rem;
    border-top: 0.2em solid rgba(255, 255, 255, 0.1);
    display: flex;
    justify-content: space-between;
    margin-bottom: 1.2em;
    padding-left: 1em;
    padding-right: 2.4em;
    position: relative;
  `,

  crown: css`
    font-size: 2.8em;
    left: 1.05em;
    position: absolute;
    top: -0.2em;
  `,

  image: css`
    height: 6.4rem;
  `,

  label: css`
    flex: 1;
    font-size: 2.4em;
    font-weight: bold;
    margin-left: 0.75em;
    margin-right: 9.1em;
  `,

  position: css`
    font-family: 'SuperMario';
    font-size: 3em;
  `,
};
