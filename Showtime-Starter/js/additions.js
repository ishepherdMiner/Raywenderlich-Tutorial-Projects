'use strict';

var mapToNative = function(movies) {
  return movies.map(function (movie) {
    // 原生代码的方法变成js的这个
    return Movie.movieWithTitlePriceImageUrl(movie.title, movie.price, movie.imageUrl);
  });
};
