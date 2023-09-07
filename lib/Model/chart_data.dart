abstract class ChartData{
  double getVal(ChartDataType type);
  DateTime getTimeStamp();

  static String getTypeName(ChartDataType t){
    switch(t){
  case ChartDataType.CPUTotal: return "Total";
  case ChartDataType.CPUUser: return "User";
  case ChartDataType.CPUSytem: return "System";
  case ChartDataType.CPUInterrupt: return "Interrupt";
  case ChartDataType.MEMUsed: return "Used";
  case ChartDataType.MEMCached: return "Cached";
  case ChartDataType.MEMBuffered: return "Buffered";
  case ChartDataType.DISKUtilization: return "Utilization";
  case ChartDataType.DISKReadSpeed: return "Read Speed";
  case ChartDataType.DISKWriteSpeed: return "Write Speed";
  case ChartDataType.NETReceivedByte: return "Received KB";
  case ChartDataType.NETReceivedDrop: return "Drops in Receive";
  case ChartDataType.NETReceivedError: return "Error in Receive";
  case ChartDataType.NETTransmitByte: return "Transmitted KB";
  case ChartDataType.NETTransmitDrop: return "Drops in transmit";
  case ChartDataType.NETTransmitError: return "Drops in Error";
      default: return '';

    }
  }
}
class ThresholdData implements ChartData{
  double yVal;
  DateTime dateTime;
  ThresholdData({required this.yVal,required this.dateTime});
  
  @override
  DateTime getTimeStamp() {
    return dateTime;
  }
  
  @override
  double getVal(ChartDataType type) {
    return yVal;
  }

}
enum ChartDataType {
  CPUTotal,
  CPUUser,
  CPUSytem,
  CPUInterrupt,
  MEMUsed,
  MEMCached,
  MEMBuffered,
  DISKUtilization,
  DISKReadSpeed,
  DISKWriteSpeed,
  NETReceivedByte,
  NETReceivedError,
  NETReceivedDrop,
  NETTransmitByte,
  NETTransmitError,
  NETTransmitDrop
}


class TestChartData implements ChartData {
  double value;
  DateTime dt;
  TestChartData(this.value,this.dt) ;
  @override
  double getVal(ChartDataType type){
    return value;
  }
  
  @override
  DateTime getTimeStamp() {
    return dt;
  }
}