import 'package:flutter/material.dart';
import 'package:toucanto_dashboard/theme/colors.dart';
import 'package:toucanto_dashboard/theme/styles.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toucanto_dashboard/utils/logic_utils.dart';
import 'global_constants.dart';
import 'package:toucanto_dashboard/page_musics/musics_home_page.dart';
import 'package:toucanto_dashboard/page_accounts/accounts_home_page.dart';
import 'package:toucanto_dashboard/page_vectors/vectors_home_page.dart';
import 'package:toucanto_dashboard/page_algorithms/algorithms_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_API_KEY,
    debug: dotenv.get('FLUTTER_ENV', fallback: 'development') == 'development',
  );

  cacheSupabaseEnums();
  cacheExtraTag();

  runApp(const ToucantoApp());
}

class ToucantoApp extends StatelessWidget {
  const ToucantoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toucanto Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: toucanticColor_Light),
      ),
      home: ToucantoMainFrame(),
    );
  }
}

class ToucantoMainFrame extends StatefulWidget {
  const ToucantoMainFrame({super.key});

  @override
  State<ToucantoMainFrame> createState() => _ToucantoMainFrameState();
}

class _ToucantoMainFrameState extends State<ToucantoMainFrame> {
  final _controller = SidebarXController(selectedIndex: 0, extended: false);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Scaffold(
          key: _key,
          appBar: isSmallScreen
              ? AppBar(
                  title: Text('Dashboard', style: basicInvertedTitle_Light()),
                  backgroundColor: toucanticDeepColor_Light,
                  shadowColor: toucanticColor_Light,
                  elevation: 4,
                )
              : null,
          body: Row(
            children: [
              if (!isSmallScreen) MainSidebarX(controller: _controller),
              Expanded(
                child: MainContent(
                  controller: _controller,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MainSidebarX extends StatelessWidget {
  const MainSidebarX({
    Key? key,
    required SidebarXController controller,
  }) : _controller = controller,
       super(key: key);

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(8),
        itemTextPadding: const EdgeInsets.symmetric(horizontal: 16),
        itemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        hoverColor: toucanticEyeColor_Light,
        textStyle: basicText_Light(),
        hoverTextStyle: basicText_Light(),
        selectedTextStyle: basicText_Light(),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 179, 179, 179),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        selectedItemDecoration: BoxDecoration(
          color: toucanticColor_Light,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        selectedItemTextPadding: EdgeInsets.only(left: 8),
        itemTextPadding: EdgeInsets.symmetric(horizontal: 24),
        itemPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      headerBuilder: (context, extended) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo_day.png',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.dashboard,
          label: 'Home',
          onTap: () {
            _controller.selectIndex(0);
          },
        ),
        SidebarXItem(
          icon: Icons.account_circle,
          label: 'Accounts',
          onTap: () {
            _controller.selectIndex(1);
          },
        ),
        SidebarXItem(
          icon: Icons.music_note,
          label: 'Musics',
          onTap: () {
            _controller.selectIndex(2);
          },
        ),
        SidebarXItem(
          icon: Icons.space_bar,
          label: 'Vectors',
          onTap: () {
            _controller.selectIndex(3);
          },
        ),
        SidebarXItem(
          icon: Icons.computer,
          label: 'Algorithms',
          onTap: () {
            _controller.selectIndex(4);
          },
        ),
      ],
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return MainPage();
          case 1:
            return const Center(child: Text('Accounts'));
          case 2:
            return MusicsHome();
          case 3:
            return const Center(child: Text('Vectors'));
          case 4:
            return const Center(child: Text('Algorithms'));
          default:
            return const Center(child: Text('Unknown Page'));
        }
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Main Content Area',
          ),
        ],
      ),
    );
  }
}
