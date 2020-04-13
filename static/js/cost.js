'use strict';

$("#cost-slider").slider({
    range: true,
    min: 0,
    max: 100000,
    values: [10000, 50000],
    slide: function (event, ui) {
        $("#cost-min").val(ui.values[0]);
        $('#cost-max').val(ui.values[1]);
    }
});
$("#cost-range").val("$" + $("#cost-slider").slider("values", 0) +
    " - $" + $("#cost-slider").slider("values", 1));


$('#form').submit(function (ev) {
    ev.preventDefault();

    let formData = {
        cost_min: $("#cost-min").val(),
        cost_max: $("#cost-max").val(),
        limit: $("#limit").val(),
    };

    console.log(formData);

    $.ajax({
        url: '/cost/data',
        type: "POST",
        contentType: 'application/json',
        data: JSON.stringify(formData),
        success: (results) => {
            $('#college_table').empty();
            results.forEach(college => {
                $("#college_table").append(`<tr>
            <th>` + college.school_name + `</th>
            <td>`+ college.men + `</td>
            <td>` + college.women + `</td>
            <td>` + college.tuition_in + `</td>
            <td>` + college.tuition_out + `</td></tr>`);
            })
        },
        error: (err) => { console.log(err) }
    });
});