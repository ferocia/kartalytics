import * as React from 'react';

type Props = {
  className?: string;
  color?: string;
};

export default function SearchIcon({className, color = 'white'}: Props) {
  return (
    <svg
      className={className}
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path d="M22 20L20 22L14 16V14H16L22 20Z" fill={color} />
      <path
        d="M9 16C5.1 16 2 12.9 2 9C2 5.1 5.1 2 9 2C12.9 2 16 5.1 16 9C16 12.9 12.9 16 9 16ZM9 4C6.2 4 4 6.2 4 9C4 11.8 6.2 14 9 14C11.8 14 14 11.8 14 9C14 6.2 11.8 4 9 4Z"
        fill={color}
      />
      <path d="M12.6238 13.4012L13.331 12.6942L15.8055 15.1695L15.0983 15.8765L12.6238 13.4012Z" fill={color} />
    </svg>
  );
}
