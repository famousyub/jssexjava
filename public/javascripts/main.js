$(document).ready(function() {
   var siliconValley;  $.getJSON('https://gist.githubusercontent.com/thekiwi/ab70294c8d7ab790d9b6d70df9d3d145/raw/725ba9da2b7d64b5a5bcf4265e6f362683a45a95/silicon-valley.json', function(data) {
      //data is the JSON string
     siliconValley = data._embedded.episodes
    console.log(siliconValley[0].name);
  });

  //$.ajax({
      // method: "post",
      // url: "/",
      // contentType: 'application/json',
      // dataType: "json",
      // data: JSON.stringify({ email: aEmail }),
      // success: function(data) {
      //   if (data == "Success") {
      //     emailAdded();
      //   } else {
      //     errorEmailAlreadyExists();
      //   }
      // }
    // });
});
