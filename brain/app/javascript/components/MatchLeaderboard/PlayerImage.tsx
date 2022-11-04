import React from 'react';
import {css} from '@emotion/react';
import * as colors from 'styles/colors';

type Props = {
  imageUrl: string;
  showCrown: boolean;
};

export default function PlayerImage({imageUrl, showCrown}: Props) {
  return (
    <React.Fragment>
      <span
        css={css`
          ${styles.avatar};
          background-image: url(${imageUrl});
        `}
      />
      {showCrown && <span css={styles.crown}>👑</span>}
    </React.Fragment>
  );
}

const styles = {
  avatar: css`
    align-self: flex-end;
    background-repeat: no-repeat;
    background-size: contain;
    height: 6em;
    margin-left: -2em;
    width: 6.5em;
  `,

  crown: css`
    font-size: 2.8em;
    left: 1.78em;
    position: absolute;
    top: -0.71em;
  `,
};
