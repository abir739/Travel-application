import 'package:flutter/material.dart';
import 'package:zenify_trip/modele/activitsmodel/usersmodel.dart';
import 'package:zenify_trip/modele/traveller/TravellerModel.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatelessWidget {
  final Traveller selectedTraveller;

  ProfilePage({required this.selectedTraveller});

  @override
  Widget build(BuildContext context) {
    User? user = selectedTraveller.user;
    double widthC = MediaQuery.of(context).size.width * 100;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 186, 137, 219),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 207, 219),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/Frame.svg',
              fit: BoxFit.cover,
              height: 36.0,
            ),
            const SizedBox(width: 40),
            const Text(
              "Traveller Profil",
              style: TextStyle(
                color: Color.fromARGB(255, 68, 5, 150),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(selectedTraveller),
            _buildMainInfo(context, widthC, selectedTraveller),
            _buildInfo(context, widthC, selectedTraveller),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Traveller selectedTraveller) {
    User? user = selectedTraveller.user;

    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://img.freepik.com/free-vector/travel-time-typography-design_1308-90406.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Ink(
          height: 200,
          decoration: const BoxDecoration(
            color: Colors.black38,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 140),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                color: Colors.grey.shade500,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white,
                      width: 6.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        user?.picture ??
                            ''
                                'https://img.freepik.com/free-vector/travel-time-typography-design_1308-99359.jpg?size=626&ext=jpg&ga=GA1.2.732483231.1691056791&semt=ais',
                        width: 80,
                        height: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMainInfo(
      BuildContext context, double width, Traveller selectedTraveller) {
    User? user = selectedTraveller.user;
    return Container(
      width: width,
      margin: const EdgeInsets.all(10),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: <Widget>[
          Text(
            '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 94, 36, 228),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user!.username ?? 'Unknown Username', // Fallback value if null
            style: TextStyle(
              color: Colors.grey.shade50,
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(
      BuildContext context, double width, Traveller selectedTraveller) {
    User? user = selectedTraveller.user;
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.email,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("E-Mail"),
                subtitle: Text(user!.email ?? 'N/A'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.phone,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("Phone Number"),
                subtitle: Text(user!.phone ?? 'N/A'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.cake,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("Birth Date"),
                subtitle: Text(
                  user!.birthDate?.toString() ?? 'N/A',
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: const Icon(
                  Icons.my_location,
                  color: Color.fromARGB(255, 94, 36, 228),
                ),
                title: const Text("Location"),
                subtitle: Text(user!.address ?? 'N/A'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
