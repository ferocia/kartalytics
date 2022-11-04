import React from 'react';
import {css} from '@emotion/react';
import {Link} from 'react-router-dom';
import * as colors from 'styles/colors';
import upLogo from 'images/up-logo.svg';
import Menu from '../components/Menu';

export default function PageHeader() {
  return (
    <div css={styles.root}>
      <div css={styles.menu}>
        <Menu />
      </div>
      <Link css={styles.link} to="/">
        <h1 css={styles.title}>
          <span css={styles.colorGreen}>K</span>
          <span css={styles.colorBlue}>A</span>
          <span css={styles.colorYellow}>R</span>
          <span css={styles.colorRed}>T</span>
          <span css={styles.colorGreen}>A</span>
          <span css={styles.colorBlue}>L</span>
          <span css={styles.colorYellow}>Y</span>
          <span css={styles.colorRed}>T</span>
          <span css={styles.colorGreen}>I</span>
          <span css={styles.colorBlue}>C</span>
          <span css={styles.colorYellow}>S</span>
        </h1>
      </Link>
      <div css={styles.love}>
        <div>
          Made with love by the team at <br />
          <small>
            @up_banking <span>&bull;</span> up.com.au
          </small>
        </div>
        <img alt="Up" src={upLogo} width="65" height="65" />
      </div>
    </div>
  );
}

const styles = {
  root: css`
    display: flex;
    grid-area: header;
    z-index: 10;
    user-select: none;
    width: 100%;
  `,

  menu: css`
    flex: 1 0 0;
    display: flex;
    align-items: center;
    justify-content: flex-end;
  `,

  link: css`
    text-decoration: none;
    margin: 0 4rem;
    display: flex;
    justify-content: center;
    flex: 0;
  `,

  title: css`
    -webkit-text-stroke: 1.6rem rgba(0, 0, 0, 0.2);
    font-family: SuperMario;
    font-size: 10rem;
    font-weight: normal;
    letter-spacing: -0.5rem;
  `,

  colorBlue: css`
    color: ${colors.blue};
  `,

  colorGreen: css`
    color: ${colors.green};
  `,

  colorRed: css`
    color: ${colors.red};
  `,

  colorYellow: css`
    color: ${colors.yellow};
  `,

  love: css`
    align-items: center;
    color: rgba(255, 255, 255, 0.6);
    display: flex;
    font-size: 2.2rem;
    height: 10rem;
    justify-content: flex-end;
    line-height: 1.4;
    flex: 1;
    white-space: nowrap;

    small {
      color: white;
      display: block;
      font-size: 1.8rem;
      text-align: right;
      user-select: text;
    }

    span {
      color: #333;
    }

    img {
      margin-left: 2rem;
    }
  `,
};
