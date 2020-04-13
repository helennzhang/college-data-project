'use strict';

$('#form').submit(function (ev) {
    ev.preventDefault();

    let formData = {
        act_low: $("#ACT-low").val(),
        act_high: $("#ACT-high").val(),
        act: $("#filter-by").val() == 'ACT' ? 1 : 0,
        sat_low: $("#SAT-low").val(),
        sat_high: $("#SAT-high").val(),
        sat: $("#filter-by").val() == 'SAT' ? 1 : 0,
        both: $("#filter-by").val() == 'both' ? 1 : 0,
    };

    console.log(formData);

    $.ajax({
        url: '/score/data',
        type: "POST",
        contentType: 'application/json',
        data: JSON.stringify(formData),
        success: (results) => {
            results.forEach(college => {
                $("#college_table").append(`<tr>
            <th>` + college.school_name + `</th>
            <td>`+ college.city + `</td>
            <td>` + college.state + `</td>
            <td>` + college.zip_code + `</td>
            <td>` + college.ugds + `</td>
            <td>` + college.admit_rate + `</td>
            <td>` + college.url + `</td></tr>`);
            })
        },
        error: (err) => { console.log(err) }
    });
});