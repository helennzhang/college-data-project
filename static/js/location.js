'use strict';

$('#form').submit(function (ev) {
    ev.preventDefault();

    let formData = {
        city: $("#city").val(),
        state: $("#state").val(),
        zip: $("#zip").val(),
    };

    console.log(formData);

    $.ajax({
        url: '/location/data',
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