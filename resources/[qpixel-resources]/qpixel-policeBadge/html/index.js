$(function () {
  window.onload = (e) => {
    $("#mdrp-badge").hide();
    window.addEventListener("message", (event) => {
      let item = event.data;
      if (item.action === "open") {
        $("#mdrp-badge").show();
        $("#badgeName").html(item.name);
        $("#badgeNumber").html(`#${item.callsign}`);
        $("#badgeImg").prop("src", item.img);
      } else if (item.action === "close") {
        $("#mdrp-badge").hide();
      } else {
        $("#mdrp-badge").hide();
      }
    });
  };
});
