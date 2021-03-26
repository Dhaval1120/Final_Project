
String TimeConvert(DateTime time)
{
  if(time.second <= DateTime.now().second-60)
    {
      return "Just now";
    }
  else
    {
      return " 10h ";
    }
  // else if(time.second > DateTime.now().second-60)
  //   {
  //     if(time.millisecond - DateTime)
  //   }
}