import 'package:flutter/material.dart';

class WatchCandidateResult extends StatelessWidget {
  final String pattern;
  WatchCandidateResult({this.pattern});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                      onPressed: () {
                        //save result in pdf file & close app
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
    );
  }

  Widget buildContent() {
    String patternCharacter;
    String patternContent;
    String patternStress;
    switch (pattern) {
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
          pattern,
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
}
