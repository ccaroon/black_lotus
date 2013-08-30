(function () {

    // Setup and start the image carousel
    $(document).ready(function () {
        $('#card_slides').carousel({
            interval: 3000
        });

        $('.carousel').carousel('cycle');
    });

}());
