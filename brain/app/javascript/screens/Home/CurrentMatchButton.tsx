import React from 'react';
import {css} from '@emotion/react';
import {Link} from 'react-router-dom';
import Heading from 'components/Heading';
import yoshi from 'images/yoshi.gif';
import * as colors from 'styles/colors';

export default function CurrentMatchButton() {
  return (
    <div css={styles.root}>
      <Link css={styles.inProgress} to="/event">
        <img css={styles.inProgressImage} src={yoshi} />
        <Heading level="3">Match in progress</Heading>
      </Link>
    </div>
  );
}

const styles = {
  root: css`
    display: flex;
    justify-content: center;
    margin-bottom: 4rem;
    width: 100%;
  `,

  inProgress: css`
    align-items: center;
    animation-direction: alternate;
    animation-duration: 1.5s;
    animation-iteration-count: infinite;
    animation-name: pulse;
    background-color: #141414;
    border-radius: 0.5rem;
    color: white;
    display: flex;
    justify-content: center;
    padding: 1.4rem 3.2rem;
    padding-left: 2.4rem;
    text-decoration: none;
    transition: all 0.1s;

    &:hover {
      background-color: rgba(255, 255, 255, 0.1);
    }
  `,

  inProgressImage: css`
    height: 3.2rem;
    margin-right: 0.7rem;
  `,
};
