import React from 'react';
import {AnimatePresence, motion} from 'framer-motion';
import {useState} from 'react';
import {Link} from 'react-router-dom';
import * as colors from 'styles/colors';
import {css} from '@emotion/react';

const MENU_ITEMS = [
  {to: '/', label: 'Home'},
  {to: '/event', label: 'Event'},
  {to: '/players', label: 'Players'},
  {to: '/leaderboard', label: 'Leaderboard'},
  {to: '/courses', label: 'Courses'},
];

const ITEM_HEIGHT = 60;
const MENU_PADDING = 30;

export default function Menu() {
  const variantsRight = {
    active2: {},
    inactive2: {...styles.rotate},
  };

  const variantsLeft = {
    active2: {opacity: 0},
    inactive2: {...styles.rotate},
  };

  const [active, setActive] = useState(false);
  return (
    <div css={styles.root}>
      <AnimatePresence>
        <div role="button" title="Menu" onClick={() => setActive(!active)} css={styles.burger}>
          <motion.div animate={{rotate: active ? 45 : 0, y: active ? 7 : 0}} css={styles.burgerLine}></motion.div>
          <motion.div animate={{rotate: active ? -45 : 0, y: active ? -7 : 0}} css={styles.burgerLine}></motion.div>
        </div>
        {active && (
          <motion.div
            key="ligma"
            animate={{height: MENU_ITEMS.length * ITEM_HEIGHT + MENU_PADDING, opacity: 1}}
            exit={{height: 0, opacity: 1}}
            transition={{duration: 0.33}}
            css={styles.menuItems}
          >
            {MENU_ITEMS.map(item => (
              <Link key={item.to} css={styles.menuItem} {...item} onClick={() => setActive(false)}>
                <motion.div key={item.to} whileHover={{scale: 1.1}}>
                  {item.label}
                </motion.div>
              </Link>
            ))}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

const styles = {
  root: css`
    position: relative;
  `,
  rotate: css`
    rotate: 45deg;
  `,
  burger: css`
    display: flex;
    flex-direction: column;
    justify-content: center;
    width: 4rem;
    cursor: pointer;
  `,
  burgerLine: css`
    background-color: white;
    height: 0.4rem;
    margin-top: 1rem;
    &:first-of-type {
      margin-top: 0;
    }
  `,
  rotateLeft: css`
    transform: rotate(45deg);
  `,
  rotateRight: css`
    transform: rotate(-45deg);
  `,
  menuItems: css`
    position: absolute;
    display: flex;
    flex-direction: column;
    margin-top: 4rem;
    left: -${MENU_PADDING}px;
    padding-left: ${MENU_PADDING}px;
    background-color: rgb(48, 48, 57);
    border-radius: 0.6rem;
    height: 0;
    overflow: hidden;
  `,
  menuItem: css`
    color: white;
    padding-right: ${MENU_PADDING}px;
    padding-bottom: ${MENU_PADDING}px;
    font-size: 3em;
    text-decoration: none;
    user-select: none;
    &:first-of-type {
      padding-top: ${MENU_PADDING}px;
    }
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
};
