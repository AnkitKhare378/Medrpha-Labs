import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EserOverviewSection extends StatelessWidget {
  const EserOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            "Overview",
            "Erythrocytes are a synonym for red blood cells. Erythrocytes have peculiar properties in terms of size, thickness and shape. "
                "When blood is added to a test tube, red blood cells (erythrocytes) drop and settle at the bottom of this tall, thin tube.\n\n"
                "ESR test means a measure of how quickly erythrocytes settle at the bottom of a test tube. "
                "Red blood cells settle at a lower rate under normal conditions. A higher-than-normal rate could suggest that the body is fighting an inflammatory process.\n\n"
                "The inflammatory reaction is a natural response of the immune system. Illness, infection or accident can be the cause of this inflammatory response. "
                "Inflammation can be due to the presence of a long-standing disease, an immunological disorder or other medical illness.\n\n"
                "Erythrocytes (red blood cells) might clump together because of an inflammatory response. "
                "In an inflammatory process, red blood cells become dense and thick. So, erythrocytes settle to the bottom more quickly.\n\n"
                "ESR results do not diagnose any diseases, but they can confirm the presence of inflammatory reactions in the body.\n\n"
                "ESR is used as an indicator of inflammatory problems. ESR reports help to monitor an existing medical condition. "
                "The ESR test isn’t a stand-alone diagnostic tool. It is often used with other tests like CRP.",
          ),

          _buildSection("Sample Type",
              "The analysis of ESR is based on a blood sample. A simple blood test determines the ESR."),

          _buildRangesSection(),

          SizedBox(height: 20,),

          _buildSection(
            "Test Result Interpretation",
            "An ESR range above or below normal does not directly diagnose diseases. "
                "It indicates inflammation and alerts doctors for further investigation.\n\n"
                "Higher ESR may be linked with:\n"
                "• Infection\n"
                "• Autoimmune diseases\n"
                "• Rheumatic fever\n"
                "• Vascular disease\n"
                "• Heart/kidney disease\n"
                "• Cancer, Anaemia, Obesity, Thyroid disease\n\n"
                "Autoimmune conditions:\n"
                "• Systemic lupus erythematosus\n"
                "• Rheumatoid arthritis\n"
                "• Temporal arteritis\n"
                "• Polymyalgia rheumatica\n"
                "• Hyperfibrinogenemia\n"
                "• Allergic vasculitis\n\n"
                "Infectious illnesses:\n"
                "• Bone infections\n"
                "• Myocarditis, pericarditis, endocarditis\n"
                "• Skin infections\n"
                "• Tuberculosis\n\n"
                "Doctors interpret ESR cautiously in cases of old age, anaemia, pregnancy, obesity.",
          ),

          _buildSection(
            "Risk Assessment",
            "Infection, Tuberculosis, Myocardium, Lymphoma, Rheumatoid Arthritis, "
                "Systemic Lupus Erythematosus, Cancers",
          ),
        ],
      ),
    );
  }

  Widget _buildRangesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ranges",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: const [
            TableRow(
              decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Category",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("ESR Range",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Males (≤ 50 years)"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("0–15 mm/hour"),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Males (> 50 years)"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("0–29 mm/hour"),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Females (≤ 50 years)"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("0–20 mm/hour"),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Females (> 50 years)"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("0–30 mm/hour"),
              ),
            ]),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "The values may vary from lab to lab. Please consult your doctor for report interpretation.\n\n"
              "A negative ESR = within normal range. A positive ESR = above normal limits.\n\n"
              "Factors such as pregnancy, menstruation, medications (like aspirin, cortisone, contraceptives, vitamin A) may alter ESR.",
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
      ],
    );
  }


  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 1.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
