

statuscheck() {
  if [ $1 -eq 0 ] ; then
       echo status = Success
               else
                  echo status = Failure
                  exit 1
                  fi
                  }