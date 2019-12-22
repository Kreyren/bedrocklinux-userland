Title: Bedrock Linux 0.7 Poki Distro Support
Nav: poki.nav

Bedrock Linux 0.7 Poki Distro Support
=====================================

How well Bedrock Linux interacts with various other Linux distributions is tracked here.

The ~{hijack~}-able column indicates whether or not there are known issues converting an install of the given distribution into Bedrock Linux via the installation script.

The ~{fetch~}-able indicates whether or not Bedrock's `brl fetch` utility is able to automatically acquire the given distribution's files for use as a Bedrock stratum.

Maintainer indicates the individual(s) responsible for maintaining Bedrock interaction with the given distro.

<table>
<tr>
<th>Distro</th>
<th>~{Hijack~}-able</th>
<th>~{Fetch~}-able</th>
<th>Maintainer</th>
</tr>
<tr>
<td>Alpine Linux</td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
<tr>
<td>Arch Linux</td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
<tr>
<td>Artix Linux</td>
<td><span style="color:#888800">Yes, but limited testing</span></td>
<td><span style="color:#888800">Experimental support</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>CentOS</td>
<td><span style="color:#aa0055">Yes, but limited testing</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
<tr>
<td>Clear Linux</td>
<td><span style="color:#aa0055">Known issues</span></td>
<td><span style="color:#888800">Experimental support</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>CRUX</td>
<td><span style="color:#aa0055">Known issues</span></td>
<td><span style="color:#aa0055">No</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>Debian</td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
<tr>
<td>Devuan</td>
<td><span style="color:#888800">Yes, but limited testing</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
<tr>
<td>Elementary OS</td>
<td><span style="color:#888800">Yes, but limited testing</span></td>
<td><span style="color:#aa0055">No</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>Exherbo</td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">Wulf C. Krueger</span></td>
</tr>
<tr>
<td>Fedora</td>
<td><span style="color:#00aa55">Yes</span></td>
<td><a href="#fedora-31-zstd">Work-around available</a></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
<tr>
<td>Gentoo Linux</td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
<tr>
<td>GoboLinux</td>
<td><span style="color:#aa0055">Known issues</span></td>
<td><span style="color:#aa0055">No</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>GuixSD</td>
<td><span style="color:#888800">Needs investigation</span></td>
<td><span style="color:#aa0055">No</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>Manjaro</td>
<td><span style="color:#888800">Yes, but pamac/octopi broken</span></td>
<td><span style="color:#aa0055">In progress</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>Mint</td>
<td><span style="color:#888800">Yes, but limited testing</span></td>
<td><span style="color:#aa0055">No</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>MX Linux</td>
<td><span style="color:#aa0055">Known issues</span></td>
<td><span style="color:#aa0055">No</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>NixOS</td>
<td><span style="color:#aa0055">Known issues</span></td>
<td><span style="color:#aa0055">No</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>OpenSUSE</td>
<td><span style="color:#aa0055">Known issues</span></td>
<td><span style="color:#888800">Experimental support</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>OpenWRT</td>
<td><span style="color:#888800">Needs investigation</span></td>
<td><span style="color:#888800">Experimental support</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<tr>
<td>Raspbian</td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
<td>Slackware Linux</td>
<td><span style="color:#aa0055">Known issues</span></td>
<td><span style="color:#888800">Experimental support</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<td>Solus</td>
<td><span style="color:#aa0055">Known issues</span></td>
<td><span style="color:#888800">Experimental Support</span></td>
<td><span style="color:#aa0055">N/A</span></td>
</tr>
<td>Ubuntu</td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
<tr>
<td>Void Linux</td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">Yes</span></td>
<td><span style="color:#00aa55">paradigm</span></td>
</tr>
</table>

### {id="fedora-31-zstd"} Fedora 31 zstd work-around

Fedora 31 [now compress their rpm packages with zstd](https://fedoraproject.org/wiki/Changes/Switch_RPMs_to_zstd_compression#Release_Notes).  As of Bedrock 0.7.10, the time of writing, `brl fetch` is unable to handle these packages.  A fix is in progress.  In the mean time, you can work around this by installing `zstd` in some stratum which provides it, then opening `/bedrock/libexec/brl-fetch` and changing [line 572](https://github.com/bedrocklinux/bedrocklinux-userland/blob/89744ead0d73b7271f4d7186956137bffc8d476e/src/slash-bedrock/libexec/brl-fetch#L572):

	dd if="\$pkg" ibs=\$o skip=1 | lzma -d

to

	dd if="\$pkg" ibs=\$o skip=1 | /bedrock/cross/bin/zstd -d

This might break fetching rpm distros which compress their rpm packages with lzma.  If so, revert the change to fetch those distros.
