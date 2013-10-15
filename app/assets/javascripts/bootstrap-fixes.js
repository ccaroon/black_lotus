(function () {

    $(document).ready(function () {
        $("a[rel=popover]").popover();
        $(".tooltip").tooltip();
        $("a[rel=tooltip]").tooltip();
        $(".date").datepicker();

        $('.typeahead.input-sm').siblings('input.tt-hint').addClass('tt-hint-sm');
        $('.typeahead.input-lg').siblings('input.tt-hint').addClass('tt-hint-lg');
    });

}());
