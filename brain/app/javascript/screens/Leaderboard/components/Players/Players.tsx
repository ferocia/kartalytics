import React from 'react';
import {css} from '@emotion/react';
import Player from './Player';
import * as colors from 'styles/colors';

type Props = {
  children: React.ReactNode;
  className?: string;
};

export default function Players({className, children}: Props) {
  return (
    <div className={className} css={styles.root}>
      {children}
    </div>
  );
}

const styles = {
  root: css`
    color: ${colors.white};
    margin: 2rem 0;
    font-size: 1rem;
  `,
};
