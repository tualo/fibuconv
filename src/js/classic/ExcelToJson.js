Ext.define('Tualo.converter.Excel', {
    singleton: true,
    onEvent: function (event) {

        var input = event.target,
            me = this;

        var reader = new FileReader();
        reader.onload = function () {
            var buffer = reader.result;
            me.toJson(buffer);
        };
        reader.readAsArrayBuffer(input.files[0]);
    },
    toJson: function (buffer) {
        if (typeof XLSX === 'undefined') {
            throw new Error('XLSX library is required in browser context');
        }

        var workbook = XLSX.read(new Uint8Array(buffer), {
            type: 'array',
            cellDates: true
        });

        var columns = [];
        for (var index = 0; index < 26; index++) {
            columns.push(String.fromCharCode(65 + index));
        }

        var result = {};
        workbook.SheetNames.forEach(function (sheetName) {
            var worksheet = workbook.Sheets[sheetName];
            var rows = XLSX.utils.sheet_to_json(worksheet, {
                header: 1,
                defval: ''
            });

            var mappedRows = rows.map(function (row) {
                var item = {};

                columns.forEach(function (columnName, columnIndex) {
                    item[columnName] = row[columnIndex] === undefined ? '' : row[columnIndex];
                });

                return item;
            });

            result[sheetName] = {
                columns: columns.slice(),
                rows: mappedRows
            };
        });

        return result;
    },

});
