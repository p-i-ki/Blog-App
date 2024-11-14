int calculateReadingTime(String content) {
  //we are splitting on the basis of space and new line.
  final wordCount = content.split(RegExp(r'\s+')).length;
  //taking avg speed of reading 225 words per minute(from google)
  const speed = 225;
  // time = wordCount/speed
  final time = wordCount / speed;
  // returning the highest value as string..
  return time.ceil();
}
