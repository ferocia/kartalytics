import React, {useEffect, useRef} from 'react';

/**
 * Calls {callback} every {delay} ms, taking into account the time it takes
 * the promise to resolve. If the promise resolution exceeds the delay, it
 * will wait for the promise to resolve then call the callback immediately.
 */
export default function useRecursiveTimeout(callback: () => Promise<unknown>, delay: number) {
  const savedCallback = useRef(callback);
  const isMounted = useRef(true);

  useEffect(() => {
    savedCallback.current = callback;
  }, [callback]);

  useEffect(() => {
    let id: NodeJS.Timeout;

    function tick() {
      const calledAt = Date.now();

      savedCallback.current().finally(() => {
        const elapsedTime = Date.now() - calledAt;
        const adjustedDelay = Math.max(delay - elapsedTime, 0);

        if (isMounted.current) {
          id = setTimeout(tick, adjustedDelay);
        }
      });
    }

    id = setTimeout(tick, delay);

    return () => {
      id && clearTimeout(id);
      isMounted.current = false;
    };
  }, []);
}
