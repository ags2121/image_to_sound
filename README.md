A final project for an Object Oriented Design course, written in Ruby.
You can run a command line user interface to the program by executing the ‘UserInterface.rb’ file.
In order to run the program you will need to have several Ruby gems, command line tools, and a specified SoundFont file installed.
The list of the dependencies are below, with links to their download pages.

<b>Dependencies</b>
<ul>
<li>Gems
  <ul>
    <li><a href="https://github.com/rmagick/rmagick">rmagick</a>
    <li><a href="https://github.com/hanklords/flickraw">flickraw</a>
    <li><a href="https://github.com/jimm/midilib">midilib</a>
  </ul>
<li>Command line tools
  <ul>
     <li><a href="http://sox.sourceforge.net">SoX</a>
     <li><a href="http://lame.sourceforge.net/using.php">lame mp3 encoder</a>
     <li><a href="http://sourceforge.net/apps/trac/fluidsynth/wiki/Download">fluidsynth midi sequencer</a>
  </ul>
<li>SoundFont File
<ol>
  <li>You can download the file <a href="http://freepats.zenvoid.org/sf2/acoustic_grand_piano_ydp_20080910.sf2">here</a>
  <li>After downloading, make sure to place the the .sf2 file in this directory: ‘/usr/share/sounds/sf2/’.
  So the path to the .sf2 file should be: ‘/usr/share/sounds/sf2/acoustic_grand_piano_ydp_20080910.sf2'
</ol>
</ul>

<b>Summary of Patterns/Architectures</b>
<ul>
<li>Layers and Facade
<li>Pipes and Filters
<li>Singleton
<li>Strategy
</ul>


<b>Index of Classes</b> (going from highest layer to lowest)
<ul>
  <li>UserInterface
  <li>ControlCenter
  <li>ImageControl
    <ul>
      <li>DataFetcher
      <li>ImagePipe
      <li>ImageFilter (base class)
      <ul>
        <li>BlurFilter, EmbossFilter, OilPaintFilter, PosterizeFilter,
        RotateFilter, ￼￼￼￼￼￼SepiaFilter
      </ul>
    </ul>
  <li>AudioControl
  <ul>
    <li>Algorithm (base class for Algorithm subtypes, AND context object in the strategy pattern)
    <ul>
      <li>TwelveToneAlgorithm
      <li>TonalAlgorithm
      <li>QuarterToneAlgorithm
    </ul>
  </ul>
</ul>
