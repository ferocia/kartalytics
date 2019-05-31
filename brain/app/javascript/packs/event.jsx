// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from "react";
import ReactDOM from "react-dom";
import PropTypes from "prop-types";

import Race from "components/Race";
import OverallResults from "components/OverallResults";

const dummyProps = {
  status: "",
  title: "Race 1 of 4",
  players: [
    { position: 3, score: 22, color: "rgb(254, 207, 0)" },
    { position: 3, score: 22, color: "rgb(25, 191, 241)" }
  ],
  race: {
    status: "finished",
    course_name: "Dry Dry Dunes",
    course_image: "foo.jpg",
    players: [
      {
        player: "player_one",
        label: "Langers",
        color: "rgb(254, 207, 0)",
        finishedAt: "+4.0s",
        data: [
          { position: 4, timestamp: "2018-08-13T02:53:21.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:21.775Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:22.775Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:22.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:23.745Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:23.745Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:24.745Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:24.755Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:25.755Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:25.755Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:26.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:26.725Z", item: null },
          {
            position: 3,
            timestamp: "2018-08-13T02:53:27.715Z",
            item: "green-shell"
          },
          { position: 3, timestamp: "2018-08-13T02:53:27.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:28.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:28.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:29.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:29.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:30.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:30.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:31.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:31.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:32.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:32.735Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:33.795Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:33.795Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:34.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:34.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:35.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:35.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:36.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:36.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:37.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:37.765Z", item: null },
          {
            position: 3,
            timestamp: "2018-08-13T02:53:39.715Z",
            item: "green-shell-triple"
          },
          { position: 3, timestamp: "2018-08-13T02:53:39.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:40.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:40.705Z", item: null },
          {
            position: 2,
            timestamp: "2018-08-13T02:53:41.715Z",
            item: "green-shell-double"
          },
          { position: 2, timestamp: "2018-08-13T02:53:41.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:42.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:42.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:43.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:43.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:44.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:44.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:45.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:45.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:46.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:46.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:47.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:47.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:48.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:48.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:49.705Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:49.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:50.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:50.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:51.705Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:51.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:52.765Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:52.775Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:53.725Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:53.725Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:54.735Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:54.735Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:55.775Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:55.775Z", item: null },
          {
            position: 5,
            timestamp: "2018-08-13T02:53:56.715Z",
            item: "green-shell-triple"
          },
          { position: 5, timestamp: "2018-08-13T02:53:56.725Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:57.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:57.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:58.725Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:58.735Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:59.735Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:59.735Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:54:00.735Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:54:00.735Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:54:01.725Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:54:01.735Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:54:02.765Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:54:02.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:03.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:03.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:04.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:04.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:05.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:05.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:06.785Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:06.785Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:07.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:07.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:08.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:08.715Z", item: null },
          {
            position: 4,
            timestamp: "2018-08-13T02:54:09.705Z",
            item: "green-shell"
          },
          { position: 4, timestamp: "2018-08-13T02:54:09.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:10.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:10.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:11.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:11.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:12.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:12.725Z", item: null },
          {
            position: 4,
            timestamp: "2018-08-13T02:54:13.765Z",
            item: "mushroom-double"
          },
          { position: 4, timestamp: "2018-08-13T02:54:13.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:14.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:14.745Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:15.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:15.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:16.755Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:16.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:17.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:17.735Z", item: null },
          {
            position: 4,
            timestamp: "2018-08-13T02:54:18.735Z",
            item: "mushroom"
          },
          { position: 4, timestamp: "2018-08-13T02:54:18.745Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:19.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:19.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:20.795Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:20.805Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:21.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:21.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:22.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:22.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:23.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:23.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:24.785Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:24.795Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:25.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:25.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:26.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:26.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:27.695Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:27.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:28.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:28.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:29.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:29.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:30.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:30.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:31.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:31.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:32.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:32.745Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:33.695Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:33.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:34.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:34.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:35.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:35.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:36.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:36.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:37.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:37.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:39.695Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:39.705Z", item: null }
        ]
      },
      {
        player: "player_two",
        label: "Carson",
        color: "rgb(25, 191, 241)",
        finishedAt: "+2.0s",
        data: [
          { position: 6, timestamp: "2018-08-13T02:53:21.765Z", item: null },
          { position: 6, timestamp: "2018-08-13T02:53:21.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:22.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:22.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:25.755Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:25.755Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:26.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:26.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:27.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:27.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:28.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:28.765Z", item: null },
          {
            position: 4,
            timestamp: "2018-08-13T02:53:29.715Z",
            item: "green-shell"
          },
          { position: 4, timestamp: "2018-08-13T02:53:29.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:30.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:30.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:31.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:31.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:32.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:32.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:33.795Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:33.795Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:34.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:34.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:35.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:35.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:36.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:36.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:37.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:37.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:38.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:38.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:39.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:39.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:40.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:40.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:41.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:41.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:42.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:42.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:43.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:43.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:44.705Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:44.705Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:45.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:45.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:46.705Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:46.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:47.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:47.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:48.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:48.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:49.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:49.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:50.715Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:50.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:51.705Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:51.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:52.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:52.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:53.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:53.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:54.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:54.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:55.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:55.775Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:56.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:56.725Z", item: null },
          {
            position: 4,
            timestamp: "2018-08-13T02:53:57.715Z",
            item: "pirhana-plant"
          },
          { position: 4, timestamp: "2018-08-13T02:53:57.715Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:58.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:58.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:59.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:53:59.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:00.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:00.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:01.725Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:01.735Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:02.765Z", item: null },
          { position: 4, timestamp: "2018-08-13T02:54:02.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:03.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:03.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:04.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:04.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:05.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:05.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:06.785Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:06.785Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:07.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:07.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:08.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:08.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:09.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:09.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:10.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:10.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:12.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:12.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:13.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:13.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:14.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:14.745Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:15.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:15.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:16.755Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:16.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:17.735Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:17.735Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:18.735Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:18.745Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:19.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:19.735Z", item: null },
          {
            position: 3,
            timestamp: "2018-08-13T02:54:20.795Z",
            item: "golden-mushroom"
          },
          { position: 3, timestamp: "2018-08-13T02:54:20.805Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:21.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:21.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:22.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:22.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:23.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:23.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:24.785Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:24.795Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:25.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:25.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:26.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:26.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:27.695Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:27.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:28.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:28.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:29.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:29.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:30.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:30.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:31.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:31.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:32.735Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:32.745Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:33.695Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:33.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:34.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:34.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:35.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:35.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:36.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:36.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:37.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:37.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:39.695Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:54:39.705Z", item: null }
        ]
      },
      {
        player: "player_three",
        label: "Wernah",
        color: "rgb(224, 38, 67)",
        finishedAt: "75.9s",
        data: [
          { position: 1, timestamp: "2018-08-13T02:53:23.745Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:23.745Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:24.745Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:24.755Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:26.715Z", item: "coin" },
          { position: 1, timestamp: "2018-08-13T02:53:26.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:27.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:27.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:28.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:28.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:29.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:29.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:30.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:30.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:31.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:31.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:32.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:32.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:33.795Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:33.795Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:34.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:34.705Z", item: null },
          {
            position: 1,
            timestamp: "2018-08-13T02:53:36.765Z",
            item: "green-shell"
          },
          { position: 1, timestamp: "2018-08-13T02:53:36.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:37.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:37.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:38.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:38.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:39.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:39.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:40.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:40.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:41.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:41.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:42.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:42.715Z", item: null },
          {
            position: 1,
            timestamp: "2018-08-13T02:53:43.705Z",
            item: "banana"
          },
          { position: 1, timestamp: "2018-08-13T02:53:43.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:44.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:44.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:45.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:45.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:46.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:46.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:47.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:47.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:48.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:48.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:49.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:49.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:50.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:50.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:51.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:51.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:52.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:52.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:53.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:53.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:54.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:54.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:55.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:55.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:56.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:56.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:57.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:57.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:58.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:58.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:59.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:53:59.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:00.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:00.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:01.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:01.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:02.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:02.775Z", item: null },
          {
            position: 1,
            timestamp: "2018-08-13T02:54:03.765Z",
            item: "green-shell"
          },
          { position: 1, timestamp: "2018-08-13T02:54:03.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:04.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:04.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:05.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:05.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:06.785Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:06.785Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:07.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:07.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:08.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:08.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:09.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:09.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:10.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:10.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:11.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:11.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:12.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:12.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:13.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:13.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:14.725Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:14.745Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:15.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:15.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:16.755Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:16.765Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:17.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:17.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:18.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:18.745Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:19.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:19.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:20.795Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:20.805Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:21.705Z", item: "coin" },
          { position: 1, timestamp: "2018-08-13T02:54:21.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:22.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:22.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:23.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:23.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:24.785Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:24.795Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:25.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:25.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:26.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:26.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:28.715Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:28.725Z", item: null },
          {
            position: 1,
            timestamp: "2018-08-13T02:54:29.705Z",
            item: "banana"
          },
          { position: 1, timestamp: "2018-08-13T02:54:29.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:30.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:30.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:31.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:31.775Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:32.735Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:32.745Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:33.695Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:33.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:35.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:35.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:36.705Z", item: null },
          { position: 1, timestamp: "2018-08-13T02:54:36.705Z", item: null }
        ]
      },
      {
        player: "player_four",
        label: "Tom",
        color: "rgb(93, 251, 60)",
        finishedAt: "+13.0s",
        data: [
          { position: 5, timestamp: "2018-08-13T02:53:21.765Z", item: null },
          { position: 5, timestamp: "2018-08-13T02:53:21.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:22.775Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:22.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:23.745Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:23.745Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:24.745Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:24.755Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:25.755Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:25.755Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:26.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:26.725Z", item: null },
          {
            position: 2,
            timestamp: "2018-08-13T02:53:27.715Z",
            item: "mushroom"
          },
          { position: 2, timestamp: "2018-08-13T02:53:27.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:28.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:28.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:29.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:29.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:30.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:30.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:31.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:31.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:32.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:32.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:33.795Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:33.795Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:34.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:34.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:35.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:35.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:36.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:36.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:37.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:37.765Z", item: null },
          {
            position: 2,
            timestamp: "2018-08-13T02:53:38.715Z",
            item: "banana"
          },
          { position: 2, timestamp: "2018-08-13T02:53:38.725Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:39.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:39.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:40.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:40.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:41.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:41.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:42.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:42.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:43.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:43.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:44.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:44.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:46.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:46.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:47.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:47.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:48.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:48.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:49.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:49.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:50.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:50.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:51.705Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:51.715Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:52.765Z", item: null },
          { position: 3, timestamp: "2018-08-13T02:53:52.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:53.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:53.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:54.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:54.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:55.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:55.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:56.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:56.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:57.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:57.715Z", item: null },
          {
            position: 2,
            timestamp: "2018-08-13T02:53:58.725Z",
            item: "mushroom-double"
          },
          { position: 2, timestamp: "2018-08-13T02:53:58.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:59.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:53:59.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:00.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:00.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:01.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:01.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:02.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:02.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:03.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:03.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:04.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:04.715Z", item: null },
          {
            position: 2,
            timestamp: "2018-08-13T02:54:05.705Z",
            item: "mushroom"
          },
          { position: 2, timestamp: "2018-08-13T02:54:05.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:06.785Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:06.785Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:07.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:07.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:08.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:08.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:09.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:09.705Z", item: null },
          {
            position: 2,
            timestamp: "2018-08-13T02:54:10.705Z",
            item: "red-shell"
          },
          { position: 2, timestamp: "2018-08-13T02:54:10.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:11.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:11.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:12.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:12.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:13.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:13.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:14.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:14.745Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:15.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:15.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:16.755Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:16.765Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:17.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:17.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:18.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:18.745Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:19.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:19.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:20.795Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:20.805Z", item: null },
          {
            position: 2,
            timestamp: "2018-08-13T02:54:21.705Z",
            item: "mushroom-triple"
          },
          { position: 2, timestamp: "2018-08-13T02:54:21.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:22.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:22.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:23.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:23.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:24.785Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:24.795Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:25.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:25.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:26.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:26.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:27.695Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:27.705Z", item: null },
          {
            position: 2,
            timestamp: "2018-08-13T02:54:28.715Z",
            item: "mushroom-double"
          },
          { position: 2, timestamp: "2018-08-13T02:54:28.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:29.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:29.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:30.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:30.705Z", item: null },
          {
            position: 2,
            timestamp: "2018-08-13T02:54:31.775Z",
            item: "mushroom"
          },
          { position: 2, timestamp: "2018-08-13T02:54:31.775Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:32.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:32.745Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:33.695Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:33.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:35.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:35.705Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:37.715Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:37.725Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:38.735Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:38.745Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:39.695Z", item: null },
          { position: 2, timestamp: "2018-08-13T02:54:39.705Z", item: null }
        ]
      }
    ]
  }
};

class Event extends React.Component {
  state = {
    event: null
  };

  componentDidMount() {
    const UPDATE_TIMEOUT = 500;
    setInterval(this.fetchUpdate.bind(this), UPDATE_TIMEOUT);
  }

  handleUpdate(data) {
    if (data && data.status) {
      this.setState({ event: data });
    }
  }

  fetchUpdate() {
    $.getJSON("/api/kartalytics/event", this.handleUpdate.bind(this));
  }

  renderCourseBestTime(best_time, course_record_set) {
    if (course_record_set) {
      return (
        <span className="best-time new-course-record">NEW COURSE RECORD!!! {best_time.toFixed(2)}s</span>
      )
    } else if (best_time) {
      return (
        <span className="best-time">Best time: {best_time.toFixed(2)}s</span>
      )
    } else {
      return null;
    }
  }

  renderCourse() {
    if (this.state.event && this.state.event.race) {
      const race = this.state.event.race;
      return (
        <div className="course">
          <h2>{race.course_name}</h2>
          <div className="course_image_container">
            <img src={race.course_image} width="300" />
          </div>
          <h3>
            {this.state.event.title}{' '}
            {this.renderCourseBestTime(race.course_best_time, race.course_record_set)}
          </h3>

        </div>
      );
    }
  }

  renderRace() {
    if (this.state.event) {
      if (this.state.event.race) {
        return (
          <React.Fragment>
            <h2>Live Graph</h2>
            <Race race={this.state.event.race} />
          </React.Fragment>
        );
      } else {
        return <p className="no-data">Waiting for race data</p>;
      }
    } else {
      return <p className="no-data">Waiting for game data</p>;
    }
  }

  renderLeaderboard() {
    if (!this.state.event) return null;

    return (
      <div className="leaderboard">
        <h2>Overall Leaderboard</h2>
        <OverallResults leaderboard={this.state.event.leaderboard} />
      </div>
    );
  }

  render() {
    return (
      <div className="wrapper">
        <div className="header">
          <h1>
            <span className="color-green">K</span>
            <span className="color-blue">A</span>
            <span className="color-yellow">R</span>
            <span className="color-red">T</span>
            <span className="color-green">A</span>
            <span className="color-blue">L</span>
            <span className="color-yellow">Y</span>
            <span className="color-red">T</span>
            <span className="color-green">I</span>
            <span className="color-blue">C</span>
            <span className="color-yellow">S</span>
          </h1>
          <div className="love">
            <div>
              Made with love by the team at <br />
              <small>@up_banking <span>&bull;</span> up.com.au</small>
            </div>
            <img src="/up-logo.svg" height="80" />
          </div>
        </div>
        <div className="aside">
          {this.renderCourse()}
          {this.renderLeaderboard()}
        </div>
        <div className="content">{this.renderRace()}</div>
      </div>
    );
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const root = document.createElement("div");
  root.id = "root";
  ReactDOM.render(<Event />, document.body.appendChild(root));
});
