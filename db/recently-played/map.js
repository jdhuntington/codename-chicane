function(doc) {
  if (doc.plays) {
    emit(doc.plays[doc.plays.length - 1], doc);
  }
}
