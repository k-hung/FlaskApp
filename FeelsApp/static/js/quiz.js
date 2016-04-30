//for rankedIndex
var emoCat1 = "";
var slideNum = 1;

function incrementSlideNum() {

  if (slideNum <= 2) {
  slideNum = slideNum + 1;
  console.log(slideNum);
  }
  else if (slideNum >= 3) {
    // if user goes through all the slides, reset the count to 1
    slideNum = 1;
    console.log(slideNum);
  }
}

function decrementSlideNum() {
  if (slideNum > 1) {
    slideNum = slideNum - 1;
    console.log(slideNum);
  }
  else if (slideNum <= 1) {
    //if user reaches left bound of slides, reset them to the end
    slideNum = 3;
    console.log(slideNum);
  }

}

function confirmSelection() {
  alert("testing 123");
  if (slideNum == 1) {
    console.log("slide1 selected");
    emoCat1 = document.getElementById("header1").innerHTML;
    //emoCat1 = $("#header0").val()

  }
  else if (slideNum == 2) {
    console.log("slide2 selected");
    emoCat1 = document.getElementById("header2").innerHTML;
    //console.log(document.getElementById("header1").innerHTML);
  }
  else if (slideNum == 3) {
    console.log("slide3 selected");
    emoCat1 = document.getElementById("header3").innerHTML;
  }

  console.log("Slide Number: " + slideNum + " Caption emotion / C1: " + emoCat1);
}
