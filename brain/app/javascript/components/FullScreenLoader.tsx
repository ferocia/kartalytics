import React from 'react';
import {css} from '@emotion/react';
import yoshi from 'images/yoshi.gif';

export default function FullScreenLoader() {
  return (
    <div
      css={css`
        background: no-repeat center center url(${yoshi});
        bottom: 0;
        left: 0;
        pointer-events: none;
        position: fixed;
        right: 0;
        top: 0;
      `}
    />
  );
}
