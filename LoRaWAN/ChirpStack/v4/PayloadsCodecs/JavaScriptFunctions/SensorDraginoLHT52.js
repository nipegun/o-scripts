function str_pad(byte) {
  var zero = '0';
  var hex = byte.toString(16);
  var tmp = 2 - hex.length;

  return zero.substr(0, tmp) + hex;
}

function decodeUplink(input) {
  return {
    data: Decode(input.fPort, input.bytes, input.variables)
  };
}

function getzf(c_num) {
  if (parseInt(c_num) < 10) {
    c_num = '0' + c_num;
  }

  return c_num;
}

function getMyDate(str) {
  var c_Date;

  if (str > 9999999999) {
    c_Date = new Date(parseInt(str));
  } else {
    c_Date = new Date(parseInt(str) * 1000);
  }

  var c_Year = c_Date.getFullYear();
  var c_Month = c_Date.getMonth() + 1;
  var c_Day = c_Date.getDate();
  var c_Hour = c_Date.getHours();
  var c_Min = c_Date.getMinutes();
  var c_Sen = c_Date.getSeconds();

  var c_Time = c_Year + '-' +
    getzf(c_Month) + '-' +
    getzf(c_Day) + ' ' +
    getzf(c_Hour) + ':' +
    getzf(c_Min) + ':' +
    getzf(c_Sen);

  return c_Time;
}

function datalog(i, bytes) {
  var aa = parseFloat(((bytes[i] << 24 >> 16 | bytes[i + 1]) / 100).toFixed(2));
  var bb = parseFloat(((bytes[i + 2] << 24 >> 16 | bytes[i + 3]) / 100).toFixed(2));
  var cc = parseFloat(((bytes[i + 4] << 24 >> 16 | bytes[i + 5]) / 10).toFixed(1));
  var dd = bytes[i + 6];
  var ee = getMyDate((bytes[i + 7] << 24 | bytes[i + 8] << 16 | bytes[i + 9] << 8 | bytes[i + 10]).toString(10));

  var string = '[' + aa + ',' + bb + ',' + cc + ',' + dd + ',' + ee + '],';

  return string;
}

function Decode(fPort, bytes, variables) {
  var decode = {};

  if (fPort == 2) {
    if (bytes.length == 11) {
      decode.TempC_SHT = parseFloat(((bytes[0] << 24 >> 16 | bytes[1]) / 100).toFixed(2));
      decode.Hum_SHT = parseFloat(((bytes[2] << 24 >> 16 | bytes[3]) / 10).toFixed(1));
      decode.TempC_DS = parseFloat(((bytes[4] << 24 >> 16 | bytes[5]) / 100).toFixed(2));
      decode.Ext = bytes[6];
      decode.Systimestamp = bytes[7] << 24 | bytes[8] << 16 | bytes[9] << 8 | bytes[10];
      decode.Node_type = "LHT52";

      return decode;
    } else {
      decode.Status = "RPL data or sensor reset";
      decode.Node_type = "LHT52";

      return decode;
    }
  }

  if (fPort == 3) {
    var data_sum = "";

    for (var i = 0; i < bytes.length; i = i + 11) {
      data_sum += datalog(i, bytes);
    }

    return {
      Node_type: "LHT52",
      DATALOG: data_sum
    };
  }

  if (fPort == 4) {
    decode.DS18B20_ID =
      str_pad(bytes[0]) +
      str_pad(bytes[1]) +
      str_pad(bytes[2]) +
      str_pad(bytes[3]) +
      str_pad(bytes[4]) +
      str_pad(bytes[5]) +
      str_pad(bytes[6]) +
      str_pad(bytes[7]);

    decode.Node_type = "LHT52";

    return decode;
  }

  if (fPort == 5) {
    decode.Sensor_Model = bytes[0];
    decode.Firmware_Version = str_pad((bytes[1] << 8) | bytes[2]);
    decode.Freq_Band = bytes[3];
    decode.Sub_Band = bytes[4];
    decode.Bat_mV = bytes[5] << 8 | bytes[6];
    decode.Node_type = "LHT52";

    return decode;
  }

  decode.Status = "Unsupported fPort";
  decode.fPort = fPort;
  decode.Node_type = "LHT52";

  return decode;
}
