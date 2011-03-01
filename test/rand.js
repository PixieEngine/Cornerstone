test("#rand", function() {
  var n = rand(2);
  ok(n === 0 || n === 1, "rand(2) gives 0 or 1");
  
  var f = rand();
  ok(f <= 1 || f >= 0, "rand() gives numbers between 0 and 1");
});