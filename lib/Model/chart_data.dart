abstract class ChartData{
  double getVal(ChartDataType type);
  DateTime getTimeStamp();
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
  DISKRSpeed,
  DISKWriteSpeed,
  NETReceived,
  NETTransmit
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