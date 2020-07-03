import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:simple_permissions/simple_permissions.dart';
import 'package:tesapp/pages/candidate/pdfPreview.dart';
import 'package:tesapp/pages/invitation_test.dart';
import 'calculateResult.dart';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/*Permission permissionFromString(String value){
  Permission permission;
  for(Permission item in Permission.values){
    if(item.toString() == value){
      permission = item;
      break;
    }
  }

  return permission;
}*/

class WatchCandidateResult extends StatefulWidget {
  final String pattern;
  final InvitationKeys invitationKey;
  final CandidateResultGraph candidateResultGraph;
  WatchCandidateResult(
      {this.pattern, this.invitationKey, this.candidateResultGraph});

  @override
  _WatchCandidateResultState createState() => _WatchCandidateResultState(
      pattern: pattern,
      invitationKey: invitationKey,
      candidateResultGraph: candidateResultGraph);
}

class _WatchCandidateResultState extends State<WatchCandidateResult> {
  final String pattern;
  final InvitationKeys invitationKey;
  final CandidateResultGraph candidateResultGraph;
  _WatchCandidateResultState(
      {this.pattern, this.invitationKey, this.candidateResultGraph});

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final pdf = pw.Document();
  //Permission _permissionStorage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_permissionStorage = permissionFromString('Permission.WriteExternalStorage');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              alignment: Alignment.center,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                            //border: Border.all(width: 2.5, color: Colors.black),
                            //borderRadius: BorderRadius.circular(24.0),
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/logos/patternLogo.jpg',
                                ),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    buildContent(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: RaisedButton(
                        onPressed: () async {
                          //save result in pdf file & close app
                          saveResult();
                          /*Directory documentDirectory =
                              await getApplicationDocumentsDirectory();
                          String documentPath = documentDirectory.path;

                          String fullPath = "$documentPath/PatternResult.pdf";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PDFPreview(
                                        path: fullPath,
                                      )));*/
                        },
                        elevation: 20.0,
                        color: Color(0xFF0513AD),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "حمل نتائجك",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                width: 30,
                                height: 40,
                                decoration: BoxDecoration(
                                    //border: Border.all(width: 2.5, color: Colors.black),
                                    //borderRadius: BorderRadius.circular(24.0),
                                    image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/logos/pdfLogo.jpg',
                                        ),
                                        fit: BoxFit.cover)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildContent() {
    String patternCharacter;
    String patternContent;
    String patternStress;
    switch (widget.pattern) {
      case 'كن سريعا':
        patternCharacter = "";
        patternContent = "";
        patternStress = "";
        break;
      case 'قم بمجهود':
        patternCharacter = "شخصية متمردة ومبدعة وعفوية ومرحة";
        patternContent =
            "دائما في حاجة إلى الشعور بالحرية وممارسة أنشطة متنوعة يتسمون بالتواطؤ في أعمالهم ويحبون اللعب والفكاهة أثناء اشتغالهم";
        patternStress =
            "قد تتسم هذه الشخصية بلوم الآخرين بسلاحها السري: سوء النية";
        break;
      case 'كن قويا':
        patternCharacter = "شخصية هادئة وواسعة الخيال";
        patternContent =
            "تقدر الهدوء والسكينة لتسمح لخيالها بالتفكير بحرية وبهدوء، تبحث دائما في عملها عن توجيهات واضحة والحصول على وقت دون إزعاج لأداء أعمالها";
        patternStress =
            "هذه الشخصية يمكن ان تجد صعوبة في التعبير عما تريد، فقد تراها أصبحت سلبية وتتجه غالبا للعزلة";
        break;
      case 'كن مثاليا':
        patternCharacter = "شخصية مثابرة وعقلانية";
        patternContent =
            "تتسم بالمسؤولية والتنظيم والمنطقية، تعطي الأولوية للكفاءة والاحتراف، بصفة عامة هي شخصية جد مثابرة ومجدة في عملها";
        patternStress =
            "هذه الشخصية تسيطر على زملائها في العمل بخصوص المواعيد والجداول الزمنية";
        break;
      case 'ارضي الاخر':
        patternCharacter = "شخصية متعاطفة";
        patternContent =
            "متعاطفة وحساسة، تفضل العمل وسط فريق، تتسم بتقديم المساعدة والاستماع ودعم الآخر، لكي يتحفزوا يحتاجون إلى معاملتهم والاعتراف بهم، ليس لعملهم أو أفكارهم، ولكن كشخص بشري لديه شعور وأحاسيس";
        patternStress =
            "ممكن أن ترتكب هذه الشخصية أخطاء غبية غير مقصودة مما يجعلها عرضة للنقد من طرف الآخرين";
        break;
    }

    return Column(
      children: <Widget>[
        Text(
          "نمطك المهيمن هو : ",
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          widget.pattern,
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3445FA)),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          "الشخصية المرتبطة بهذا النمط هى : ",
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          patternCharacter,
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3445FA)),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          "شخصيتك هى " + patternContent,
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          "فى حالة التوتر والضغط",
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3445FA)),
        ),
        Text(
          patternStress,
          textDirection: TextDirection.rtl,
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }

  Future<String> writeOnPDF() async {
    pdf.addPage(pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: pw.Font.ttf(
              await rootBundle.load('assets/fonts/amiri/Amiri-Regular.ttf')),
          bold: pw.Font.ttf(
              await rootBundle.load('assets/fonts/amiri/Amiri-Bold.ttf')),
        ),
        margin: pw.EdgeInsets.all(15),
        build: (pw.Context context) {
          //print(widget.candidateResultGraph.ansScoreAR);
          //print(widget.candidateResultGraph.ansScoreFR);
          final lineChart = pw.Chart(
              grid: pw.CartesianGrid(
                xAxis: pw.FixedAxis.fromStrings(
                    List<String>.generate(
                        widget.candidateResultGraph.ansScoreAR.length,
                        (index) => widget.candidateResultGraph.ansScoreFR.keys
                            .elementAt(index)),
                    marginStart: 25),
                yAxis: pw.FixedAxis([
                  0,
                  2,
                  4,
                  6,
                  8,
                  10,
                  12,
                  14,
                  16,
                  18,
                  20,
                  22,
                  24,
                  26,
                  28,
                  30,
                  32,
                  34,
                  36,
                  38,
                  40
                ], divisionsWidth: 1.5, divisions: true
                    // to draw horizontal lines
                    ),
              ),
              datasets: [
                pw.BarDataSet(
                  color: PdfColors.orange,
                  width: 10,
                  offset: -10,
                  borderColor: PdfColors.orange,
                  data: List<pw.LineChartValue>.generate(
                      widget.candidateResultGraph.ansScoreAR.length, (index) {
                    final int arScore = widget
                        .candidateResultGraph.ansScoreAR.values
                        .elementAt(index);
                    String percentageARScore = ((arScore.toDouble() /
                                widget.candidateResultGraph.percentageAR) *
                            100)
                        .toStringAsFixed(1);
                    return pw.LineChartValue(
                        index.toDouble(), double.parse(percentageARScore));
                  }),
                ),
                pw.BarDataSet(
                  color: PdfColors.lightBlue,
                  width: 10,
                  offset: 10,
                  borderColor: PdfColors.lightBlue,
                  data: List<pw.LineChartValue>.generate(
                      widget.candidateResultGraph.ansScoreFR.length, (index) {
                    final int frScore = widget
                        .candidateResultGraph.ansScoreFR.values
                        .elementAt(index);
                    String percentageFRScore = ((frScore.toDouble() /
                                widget.candidateResultGraph.percentageFR) *
                            100)
                        .toStringAsFixed(1);
                    return pw.LineChartValue(
                        index.toDouble(), double.parse(percentageFRScore));
                  }),
                )
              ]);
          return <pw.Widget>[
            //............. first page ...............
            pw.SizedBox(height: 30.0),
            pw.Center(
                child: pw.Text("تقرير إختبار تحديد الأنماط المهيمنة",
                    textDirection: pw.TextDirection.rtl,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        color: PdfColors.blueGrey,
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold))),
            pw.SizedBox(height: 20.0),
            pw.Center(
                child: pw.Text("إسم المترشح",
                    textDirection: pw.TextDirection.rtl,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold))),
            pw.Center(
                child: pw.Text(widget.invitationKey.email,
                    textDirection: pw.TextDirection.rtl,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        color: PdfColors.black,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold))),

            //............. second page ..............
            pw.NewPage(),
            pw.SizedBox(height: 20.0),
            pw.Center(
                child: pw.Table.fromTextArray(
              border:
                  pw.TableBorder(horizontalInside: true, verticalInside: true),
              headerAlignment: pw.Alignment.center,
              cellAlignment: pw.Alignment.center,
              headers: ['إسم المستشار', 'البريد الإلكترونى للمترشح'],
              headerStyle: pw.TextStyle(
                  fontSize: 15.0,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(
                  fontSize: 15.0,
                  color: PdfColors.black,
                  fontWeight: pw.FontWeight.bold),
              data: [
                [widget.invitationKey.invitedBy, widget.invitationKey.email]
              ],
            )),
            pw.SizedBox(height: 15.0),
            pw.Center(
                child: pw.Text("الأنماط المهيمنة",
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                        color: PdfColors.red,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 20.0))),
            pw.SizedBox(height: 15.0),
            pw.Text("فيما يلى نتائج إختبار تحديد الأنماط المهيمنة لديك :",
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                    color: PdfColors.black,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 15.0)),
            pw.SizedBox(height: 15.0),
            pw.Text("نتائج الأختبار بالعربية :",
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                    color: PdfColors.blue500,
                    decoration: pw.TextDecoration.underline,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 25.0)),
            pw.SizedBox(height: 15.0),
            pw.Row(
              children: <pw.Widget>[
                pw.Expanded(
                    flex: 2,
                    child: pw.Container(
                        padding: pw.EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 12.0),
                        decoration: pw.BoxDecoration(
                            border: pw.BoxBorder(
                                color: PdfColors.black,
                                left: true,
                                right: true,
                                bottom: true,
                                top: true)),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: <pw.Widget>[
                              pw.Text("نتائج الإختبارين",
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 25.0)),
                              pw.SizedBox(height: 15.0),
                              lineChart,
                              pw.SizedBox(height: 15.0),
                              pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceEvenly,
                                  children: <pw.Widget>[
                                    pw.Row(
                                      children: <pw.Widget>[
                                        pw.Container(
                                            width: 18,
                                            height: 18,
                                            decoration: pw.BoxDecoration(
                                                shape: pw.BoxShape.rectangle,
                                                color: PdfColors.orange)),
                                        pw.SizedBox(width: 5.0),
                                        pw.Text("النتائج بالعربية",
                                            textDirection: pw.TextDirection.rtl,
                                            style: pw.TextStyle(
                                                color: PdfColors.black,
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 17.0))
                                      ],
                                    ),
                                    pw.Row(
                                      children: <pw.Widget>[
                                        pw.Container(
                                            width: 18,
                                            height: 18,
                                            decoration: pw.BoxDecoration(
                                                shape: pw.BoxShape.rectangle,
                                                color: PdfColors.lightBlue)),
                                        pw.SizedBox(width: 5.0),
                                        pw.Text("النتائج بالفرنسية",
                                            textDirection: pw.TextDirection.rtl,
                                            style: pw.TextStyle(
                                                color: PdfColors.black,
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 17.0))
                                      ],
                                    ),
                                  ])
                            ]))),
                pw.SizedBox(width: 8.0),
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                      children: <pw.Widget>[
                        pw.Text("نتائجك فى الأختبارين تقول ان نمطك المهيمن هو",
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                color: PdfColors.black, fontSize: 17.0)),
                        pw.Text(widget.pattern,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              color: PdfColors.blue800,
                              fontSize: 30.0,
                              fontWeight: pw.FontWeight.bold,
                            )),
                      ]),
                ),
              ],
            ),
            //............ third page ............
            pw.NewPage(),
            pw.SizedBox(height: 20.0),
            pw.Center(
                child: pw.Text("تعرف على نمطك اكثر من خلال هذا الجدول:",
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                        color: PdfColors.blueAccent700,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 20.0))),
            pw.SizedBox(height: 10),

            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder(
                    horizontalInside: true, verticalInside: true),
                children: [
                  //......... first row .............
                  pw.TableRow(
                    decoration:
                        pw.BoxDecoration(color: PdfColors.blueAccent100),
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topCenter,
                        padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                        child: pw.Text('عبارات متداولة عند أصحاب هذا النمط',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 20.0)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topCenter,
                        padding: pw.EdgeInsets.symmetric(horizontal: 20.0),
                        child: pw.Text('مميزاتهم',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 20.0)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topCenter,
                        padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                        child: pw.Text('النمط',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 20.0)),
                      ),
                    ],
                  ),
                  // ........... second row ............
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: <pw.Widget>[
                            pw.Text('أنت تتسكع هناك!',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"!أسرع!"نحن لا نزال متأخرين بسببك',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0))
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Text(
                          'هؤلاء الناس دائما نشطون, وصبرهم ينفذ بسرعة, وهم يركضون دائماً',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 15.0)),
                    ),
                    pw.Container(
                      color: PdfColors.blueAccent400,
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      child: pw.Text('كن سريعا',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20.0)),
                    ),
                  ]),
                  //.......... third row ............
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: <pw.Widget>[
                            pw.Text('لا شئ يتحقق بدون حد أدنى للجهد.',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('ليس لدينا شئ بدون أى شئ.',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('إفعل المزيد',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('أنت لا تعمل بما فيه الكفاية',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('يبدو لى أنك لم تقضي وقتاً كافياً',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0))
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: <pw.Widget>[
                            pw.Text(
                                'الأشخاص الذين يسعون إلى تجاوز الآخرين, للقيام بعمل أفضل',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text(
                                'غالباً ما ينتقدون الآخرين الذين لا يفعلون ما يكفى فى أعينهم',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0))
                          ]),
                    ),
                    pw.Container(
                      color: PdfColors.orange300,
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      child: pw.Text('قم بمجهود',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 17.0)),
                    ),
                  ]),
                  //.......... fourth row .............
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: <pw.Widget>[
                            pw.Text('يجب أن تكون الأول فى صفك.',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('طمأننى, هل حصلت على أفضل علامة ؟',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('من هو الأول ؟',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('رسالتك لم يتم تتبعها بشكل جيد.',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('لقد تجاوزت صفحة التلوين الخاصة بك.',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('إفعلها مرة أخرى حتى تصبح مثالية',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0))
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: pw.Alignment.topCenter,
                      child: pw.Text(
                          'الأشخاص الذين لا يوجد شئ جيد لهم بما يكفي, الكماليون, هم دائماً غير راضيين عما فعلوه وما يفعله الآخرون',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 15.0)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      child: pw.Text('كن مثالى',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20.0)),
                    ),
                  ]),
                  //......... fifth row ...........
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: <pw.Widget>[
                            pw.Text('"هل أنت فتاة تبكى هكذا ؟"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"كن شجاعاً"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"لا يوجد سبب للخوف"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"أنت حساس جداً"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"لا أريد أن اراك تبكى"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"الأطفال الآخرون أكثر حزناً منك"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"الحياة صعبة ما رأيك ؟"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"أنا فى عمرك كنت أعمل بالفعل."',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0))
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                          'هم أشخاص لا يعبرون عن مشاعرهم ابداً, يواجهون الشدائد وهم مبتسمون, لا يعرفون كيف يسمحون لأنفسهم, ويركهون الضعف',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 15.0)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.yellow200,
                      ),
                      child: pw.Text('كن قويا',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20.0)),
                    ),
                  ]),
                  //........... 6th row .........
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: <pw.Widget>[
                            pw.Text('"هل تريد أذيتي حقاً ؟"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"كن مؤدباً."',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"ستكون لطيفاً إذا ..."',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"لا أريد أن تفعل ذلك."',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"هل تعتقد أننى لا أستحق ذلك ؟"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"<< << قدم لى معروف >> >>"',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('"سوف تقدمون خدمة لكل فرد بهذه الطريقة."',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                          'هم الأشخاص  المرتبطين بشركائهم الذين يخافون دائماً من إرتكاب الأخطاء, يسعون دائماً إلى إرضاء والقيام بما يتوقعه الآخرون منهم',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 15.0)),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blueGrey100,
                      ),
                      child: pw.Text('إرضي الآخر',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 17.0)),
                    ),
                  ])
                ]),

            pw.NewPage(),
            pw.SizedBox(height: 20.0),
            pw.Center(
                child: pw.Text("إيجابيات وسلبيات كل نمط",
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(
                        height: 10.0,
                        color: PdfColors.blueAccent700,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 25.0))),
            pw.SizedBox(height: 15),
            pw.Center(
                child: pw.Text("إعرف إيجابيات وسلبيات نمطك المهيمن",
                    textDirection: pw.TextDirection.rtl,
                    style: pw.TextStyle(fontSize: 20.0))),
            pw.SizedBox(height: 15),
            pw.Table(
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                border: pw.TableBorder(
                    horizontalInside: true, verticalInside: true),
                children: [
                  //......... first row .............
                  pw.TableRow(
                    decoration:
                        pw.BoxDecoration(color: PdfColors.blueAccent100),
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.topCenter,
                        padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                        child: pw.Text('سلبيات هذا النمط',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 20.0)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topCenter,
                        padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                        child: pw.Text('إيجابيات هذا النمط',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 20.0)),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topCenter,
                        padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                        child: pw.Text('النمط',
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 20.0)),
                      ),
                    ],
                  ),
                  // ........... second row ............
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('نفاد الصبر',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('سريع ولكن ليس جيداً بالضرورة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('غير واقعى من وجهة نظر تنظيمية',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الإجهاد والمزاج السئ',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0))
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('إحترام المواعيد النهائية',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الديناميكية',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('القدرة على التصرف فى وقت سريع',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('رد الفعل',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0))
                          ]),
                    ),
                    pw.Container(
                      color: PdfColors.blueAccent400,
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      child: pw.Text('كن سريعا',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20.0)),
                    ),
                  ]),
                  //.......... third row ............
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text(
                                'تحتاج إلى جعل كل مهمة أكثر تعقيداً, كل علاقة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('عدم القدرة على الأستمتاع بمتع بسيطة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('صعوبة الوصول إلى الهدف فى التوقيت',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('مرهق',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('قدرة عمل كبيرة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الإيثار',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('عزيمة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                          ]),
                    ),
                    pw.Container(
                      color: PdfColors.orange300,
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      child: pw.Text('قم بمجهود',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 17.0)),
                    ),
                  ]),
                  //.......... fourth row .............
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('إستياء دائم',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('تعصب',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('مطالب عالية للغاية مع الذات والآخرين',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text(
                                'التباعد )الخوف من فعل الشئ الخطأ الذي يشجعك على التأخير(',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الخوف من الفشل',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الخوف من حكم الآخرين',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: pw.Alignment.topCenter,
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('إرادة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('العناد',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الكمالية, والدقة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الوعى )بالمعني الجاد(',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الالتزام والمشاركة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      child: pw.Text('كن مثالى',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20.0)),
                    ),
                  ]),
                  //......... fifth row ...........
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('الإستماع إلى العواطف )ودفنها(',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الأعتلال النفسى',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('عدم تحمل العاطفة والضعف',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('عدم القدرة على التفويض',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text(
                                'صعوبات العمل فى الفريق لأن ذلك يعزز العمل الفردى والمنافسة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الصراع',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('طموح',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: pw.Alignment.center,
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('القيادة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('التحكم فى المشاعر',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('المثابرة والحتمية',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('طموح',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.yellow200,
                      ),
                      child: pw.Text('كن قويا',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 20.0)),
                    ),
                  ]),
                  //........... 6th row .........
                  pw.TableRow(children: <pw.Widget>[
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('الخوف من خيبة الأمل',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('عدم الفدرة على التعبير عن رأيك',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('عدم القدرة على الرفض',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('إهمال الحاجات / الرغبات',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('الشعور بالذنب',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('إحترام الذات متدنى',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: pw.Alignment.center,
                      child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: <pw.Widget>[
                            pw.Text('الإيثار',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('مهارات إستماع رائعة',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                            pw.Text('التعاطف',
                                textDirection: pw.TextDirection.rtl,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15.0)),
                          ]),
                    ),
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blueGrey100,
                      ),
                      child: pw.Text('إرضي الآخر',
                          textDirection: pw.TextDirection.rtl,
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 17.0)),
                    ),
                  ])
                ]),
          ];
        },
        footer: (pw.Context context) {
          return pw.Footer(
              title: pw.Text(context.pageNumber.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 15.0, fontWeight: pw.FontWeight.bold)));
        }));

    /*pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load('assets/fonts/amiri/Amiri-Regular.ttf')),
        bold: pw.Font.ttf(
            await rootBundle.load('assets/fonts/amiri/Amiri-Bold.ttf')),
      ),
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.SizedBox(height: 10.0),
          /*pw.Table(
              border:
                  pw.TableBorder(horizontalInside: true, verticalInside: true),
              children: [
                pw.TableRow(children: [
                  pw.Text('المكان', textDirection: pw.TextDirection.rtl),
                  pw.Text('الزمان', textDirection: pw.TextDirection.rtl),
                  pw.Text('اين انا', textDirection: pw.TextDirection.rtl),
                ],),
                pw.TableRow(children: [
                  pw.Text('المكان', textDirection: pw.TextDirection.rtl),
                  pw.Text('الزمان', textDirection: pw.TextDirection.rtl),
                  pw.Text('اين انا', textDirection: pw.TextDirection.rtl),
                ]),
              ]),*/
          pw.Center(
              child: pw.Table.fromTextArray(
            border:
                pw.TableBorder(horizontalInside: true, verticalInside: true),
            headerAlignment: pw.Alignment.center,
            cellAlignment: pw.Alignment.center,
            headers: ['إسم المستشار', 'البريد الإلكترونى للمترشح'],
            headerStyle: pw.TextStyle(
                color: PdfColors.black, fontWeight: pw.FontWeight.bold),
            data: [
              [invitationKey.invitedBy, invitationKey.email]
            ],
          )),
        ]);
      },
    ));*/
    //print("writedSuccess");

    //await saveResult();
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;

    String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    timestamp = documentPath + '/PatternResult' + timestamp;
    //String filePath = '/storage/emulated/0/Documents/${timestamp}';

    return timestamp;
  }

  void saveResult() async {
    /*Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    /*
    content://com.android.externalstorage.documents/document/primary%3ADocuments%2FResults
    */
    print(documentPath);
    File file = File("$documentPath/PatternResult.pdf");
    file.writeAsBytesSync(pdf.save());*/

    /*bool hasStorage = await SimplePermissions.checkPermission(_permissionStorage);
    if(hasStorage == false){
      showInSnackBar('غير قادر على الوصول للملفات لحفظ الملف المطلوب!');
      return;
    }*/

    writeOnPDF().then((String filePath){
      if(filePath != null){
        File file = File("${filePath}.pdf");
        file.writeAsBytesSync(pdf.save());
        showInSnackBar('تم حفظ الملف فى هذا المسار ${filePath}');
      }
    });
    
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Directionality(
            textDirection: TextDirection.rtl, child: new Text(value))));
  }
}
