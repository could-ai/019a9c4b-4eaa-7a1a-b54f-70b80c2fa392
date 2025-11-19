import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoLandingPage extends StatefulWidget {
  const VideoLandingPage({super.key});

  @override
  State<VideoLandingPage> createState() => _VideoLandingPageState();
}

class _VideoLandingPageState extends State<VideoLandingPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Using a reliable public video URL for demonstration
    // In a real app, you might use an asset or your own hosted video
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'), 
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.setVolume(0.0); // Mute is often required for autoplay on web
        _controller.play();
      }).catchError((error) {
        debugPrint("Video initialization error: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Video Background Layer
          Positioned.fill(
            child: _isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(
                    color: Colors.black, // Fallback color
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white24),
                    ),
                  ),
          ),

          // 2. Gradient Overlay Layer (to make text readable)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // 3. Content Layer
          const ContentLayer(),
        ],
      ),
    );
  }
}

class ContentLayer extends StatelessWidget {
  const ContentLayer({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive layout builder
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;
        
        return Column(
          children: [
            // Navigation Bar
            NavBar(isDesktop: isDesktop),
            
            // Main Hero Content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AnimatedEntrance(
                          delay: Duration(milliseconds: 200),
                          child: Text(
                            "INNOVATION AWAITS",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 400),
                          child: Text(
                            "Build The Future\nWith Flutter",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: isDesktop ? 72 : 42,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 600),
                          child: Text(
                            "Experience seamless design and powerful performance\nacross all platforms with a single codebase.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isDesktop ? 20 : 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        AnimatedEntrance(
                          delay: const Duration(milliseconds: 800),
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            children: [
                              HoverButton(
                                text: "Get Started",
                                isPrimary: true,
                                onPressed: () {},
                              ),
                              HoverButton(
                                text: "Watch Demo",
                                isPrimary: false,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Footer / Bottom spacing
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }
}

// --- Reusable Components ---

class NavBar extends StatelessWidget {
  final bool isDesktop;
  const NavBar({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          const Row(
            children: [
              Icon(Icons.play_circle_fill, color: Colors.blueAccent, size: 32),
              SizedBox(width: 12),
              Text(
                "COULDAI",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          
          // Links (Hidden on mobile for simplicity in this demo)
          if (isDesktop)
            Row(
              children: [
                _NavLink(text: "Home"),
                _NavLink(text: "Features"),
                _NavLink(text: "Pricing"),
                _NavLink(text: "Contact"),
                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  child: const Text("Sign In"),
                )
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String text;
  const _NavLink({required this.text});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: _isHovered ? Colors.blueAccent : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}

class HoverButton extends StatefulWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;

  const HoverButton({
    super.key,
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered ? Colors.blueAccent : Colors.blue)
                : (_isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent),
            border: Border.all(
              color: widget.isPrimary ? Colors.transparent : Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: _isHovered && widget.isPrimary
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    )
                  ]
                : [],
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const AnimatedEntrance({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<AnimatedEntrance> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}
