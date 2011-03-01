/**
 * Returns random integers from [0, n) if n is given.
 * Otherwise returns random float between 0 and 1.
 *
 * @param {Number} n
 */
function rand(n) {
  if(n) {
    return Math.floor(n * Math.random());
  } else {
    return Math.random();
  }
}
