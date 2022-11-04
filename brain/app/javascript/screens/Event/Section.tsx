import React from 'react';
import Heading from 'components/Heading';

type Props = {
  title: string;
  component: React.ReactNode;
};

export default function Section({title, component}: Props) {
  return (
    <React.Fragment>
      <Heading level="2">{title}</Heading>
      {component}
    </React.Fragment>
  );
}
