
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String TimeConvert(time)
{
   DateTime timeToConvert = DateTime.fromMillisecondsSinceEpoch(time);
   DateTime now = DateTime.now();
   Duration difference = now.difference(timeToConvert);
   //print(" Difference is ${now.difference(timeToConvert)}");
   if(difference.inSeconds < 60)
     {
       print(" Difference sec is ${now.difference(timeToConvert).inSeconds}");
       return now.difference(timeToConvert).inSeconds.toString() + 'sec';
     }
   else if(difference.inMinutes < 60 && difference.inSeconds > 60)
     {
       print(" Difference min is ${now.difference(timeToConvert).inMinutes}");
       return now.difference(timeToConvert).inMinutes.toString() + 'min';
     }
   else if(difference.inMinutes > 60 && difference.inSeconds > 60 && difference.inHours < 24)
     {
       print(" Difference hour is ${now.difference(timeToConvert).inHours}");
       return now.difference(timeToConvert).inHours.toString() + "hr";
     }
   else if(difference.inMinutes > 60 && difference.inSeconds > 60 && difference.inHours > 24)
     {
       print(" Difference day is ${now.difference(timeToConvert).inDays}");
       return  now.difference(timeToConvert).inDays.toString() + "days";
     }
   else
     {
       return DateFormat.yMd().format( DateTime.fromMillisecondsSinceEpoch(time));
     }
   // print("Seconds ${now.second} ${timeToConvert.second}");
   // print("Hours ${now.hour} ${timeToConvert.hour}");
   // print("Minutes ${now.minute} ${timeToConvert.minute}");
   // print("Year ${now.year} ${timeToConvert.year}");
}