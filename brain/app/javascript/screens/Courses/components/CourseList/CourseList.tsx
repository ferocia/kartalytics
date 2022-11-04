import React, {useState} from 'react';
import {css} from '@emotion/react';
import {Link} from 'react-router-dom';
import {motion} from 'framer-motion';
import escapeRegExp from 'lodash/escapeRegExp';
import type {Entities} from 'types';
import SearchBar from 'components/PlayerList/SearchBar';

type Props = {
  courses: Entities.Course[];
};

export default function CourseList({courses}: Props) {
  const [searchValue, setSearchValue] = useState('');

  function handleInput(event: React.ChangeEvent<HTMLInputElement>) {
    setSearchValue(event.target.value);
  }

  const filterdCourses = courses.filter(({name}) => new RegExp(escapeRegExp(searchValue), 'i').test(name));

  return (
    <div css={styles.root}>
      <SearchBar onInput={handleInput} placeholder="Search by course name" value={searchValue} />

      <div css={styles.courses}>
        {filterdCourses.map(course => {
          if (course.name === 'Unknown Course') return null;
          return (
            <motion.div css={styles.course} key={course.id} whileHover={{scale: 1.033}}>
              <Link css={styles.link} title={course.name} to={`/courses/${course.name}`}>
                <img css={styles.img} src={course.image} width="256" height="236" />
                {course.champion && (
                  <div css={styles.championContainer}>
                    <img css={styles.champion} src={course.champion.image_url} />
                  </div>
                )}
              </Link>
            </motion.div>
          );
        })}
      </div>
    </div>
  );
}

const styles = {
  root: css`
    align-items: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
    margin-top: 3rem;
  `,

  courses: css`
    align-items: center;
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
    margin-top: 3rem;
  `,

  course: css`
    display: flex;
    width: 40rem;
    height: 22.5rem;
    margin: 1rem;
    position: relative;
  `,

  img: css`
    width: 100%;
    height: auto;
    border-radius: 0.4rem;
  `,

  link: css`
    flex-direction: column;
    color: white;
    border-radius: 0.6rem;
    text-decoration: none;
  `,

  championContainer: css`
    background: radial-gradient(
        ellipse farthest-corner at right bottom,
        #fedb37 0%,
        #fdb931 8%,
        #9f7928 30%,
        #8a6e2f 40%,
        transparent 80%
      ),
      radial-gradient(
        ellipse farthest-corner at left top,
        #ffffff 0%,
        #ffffac 8%,
        #d1b464 25%,
        #5d4a1f 62.5%,
        #5d4a1f 100%
      );
    border-radius: 50%;
    overflow: hidden;
    position: absolute;
    left: 1rem;
    top: 1rem;
    width: 4.5rem;
    height: 4.5rem;
    z-index: 1;
    display: flex;
    justify-content: center;
    box-shadow: 2px 7px 34px 0px rgba(0, 0, 0, 0.66);
    -webkit-box-shadow: 2px 7px 34px 0px rgba(0, 0, 0, 0.66);
    -moz-box-shadow: 2px 7px 34px 0px rgba(0, 0, 0, 0.66);
  `,

  champion: css`
    height: 4.5rem;
    margin-bottom: -0.5rem;
  `,
};
