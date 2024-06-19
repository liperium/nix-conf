{ fetchNuGet }:
[
  (fetchNuGet {
    pname = "EnvDTE";
    version = "8.0.2";
    sha256 = "1wdvjzdmqbqyqlaijpjc959vvdic12vqr3c5sffhbxi7m1si5k63";
  })
  (fetchNuGet {
    pname = "JetBrains.Annotations";
    version = "2019.1.3";
    sha256 = "188b0qw6lih0k3ddnmimadzr3y1y6vh6ramgkjnyskqd43prjzc2";
  })
  (fetchNuGet {
    pname = "JetBrains.Rider.PathLocator";
    version = "1.0.4";
    sha256 = "1s3jwhc7sxbx0240jfaclnqz28mxp9q8qqwp1fgh9g3vd111kby5";
  })
  (fetchNuGet {
    pname = "Microsoft.Build";
    version = "15.1.548";
    sha256 = "1aqb5rv71zvx7a49kk83ra5xbsj2mwzfszaabqqa8kxdzhcx7amz";
  })
  (fetchNuGet {
    pname = "Microsoft.Build.Framework";
    version = "15.1.548";
    sha256 = "1f7p6ry58b70q88frnmiv8wldvir44gxfcgcyj9a7d4zs409fkni";
  })
  (fetchNuGet {
    pname = "Microsoft.Build.Locator";
    version = "1.2.6";
    sha256 = "1rnfd7wq2bkynqj767xmq9ha38mz010fmqvvvrgb4v86gd537737";
  })
  (fetchNuGet {
    pname = "Microsoft.Build.NoTargets";
    version = "2.0.1";
    sha256 = "1f567mxyrd75kn37kqh5ywv2aj3vdshs276i80if9jhswkya4sp4";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.Analyzers";
    version = "3.3.3";
    sha256 = "09m4cpry8ivm9ga1abrxmvw16sslxhy2k5sl14zckhqb1j164im6";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.Common";
    version = "3.10.0";
    sha256 = "12a7wq45liw89ylnf2b7v374s3m0lbknkx7kazk3bf6nd1b8ny81";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.Common";
    version = "3.8.0";
    sha256 = "12n7rvr39bzkf2maw7zplw8rwpxpxss4ich3bb2pw770rx4nyvyw";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.CSharp";
    version = "3.10.0";
    sha256 = "0plpvimh9drip1fvic3zfg1gmiw3q8xb85nqjqy1hq140p4him6k";
  })
  (fetchNuGet {
    pname = "Microsoft.CodeAnalysis.CSharp";
    version = "3.8.0";
    sha256 = "1kmry65csvfn72zzc16vj1nfbfwam28wcmlrk3m5rzb8ydbzgylb";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Platforms";
    version = "1.0.1";
    sha256 = "01al6cfxp68dscl15z7rxfw9zvhm64dncsw09a1vmdkacsa2v6lr";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Platforms";
    version = "1.1.0";
    sha256 = "08vh1r12g6ykjygq5d3vq09zylgb84l63k49jc4v8faw9g93iqqm";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Platforms";
    version = "5.0.0";
    sha256 = "0mwpwdflidzgzfx2dlpkvvnkgkr2ayaf0s80737h4wa35gaj11rc";
  })
  (fetchNuGet {
    pname = "Microsoft.NETCore.Targets";
    version = "1.0.1";
    sha256 = "0ppdkwy6s9p7x9jix3v4402wb171cdiibq7js7i13nxpdky7074p";
  })
  (fetchNuGet {
    pname = "Microsoft.NETFramework.ReferenceAssemblies";
    version = "1.0.0";
    sha256 = "0na724xhvqm63vq9y18fl9jw9q2v99bdwr353378s5fsi11qzxp9";
  })
  (fetchNuGet {
    pname = "Microsoft.NETFramework.ReferenceAssemblies.net461";
    version = "1.0.0";
    sha256 = "00vkn4c6i0rn1l9pv912y0wgb9h6ks76qah8hvk441nari8fqbm1";
  })
  (fetchNuGet {
    pname = "Microsoft.NETFramework.ReferenceAssemblies.net472";
    version = "1.0.0";
    sha256 = "1bqinq2nxnpqxziypg1sqy3ly0nymxxjpn8fwkn3rl4vl6gdg3rc";
  })
  (fetchNuGet {
    pname = "Microsoft.Win32.Primitives";
    version = "4.0.1";
    sha256 = "1n8ap0cmljbqskxpf8fjzn7kh1vvlndsa75k01qig26mbw97k2q7";
  })
  (fetchNuGet {
    pname = "Microsoft.Win32.Registry";
    version = "4.0.0";
    sha256 = "1spf4m9pikkc19544p29a47qnhcd885klncahz133hbnyqbkmz9k";
  })
  (fetchNuGet {
    pname = "Microsoft.Win32.Registry";
    version = "5.0.0";
    sha256 = "102hvhq2gmlcbq8y2cb7hdr2dnmjzfp2k3asr1ycwrfacwyaak7n";
  })
  (fetchNuGet {
    pname = "NETStandard.Library";
    version = "2.0.3";
    sha256 = "1fn9fxppfcg4jgypp2pmrpr6awl3qz1xmnri0cygpkwvyx27df1y";
  })
  (fetchNuGet {
    pname = "Newtonsoft.Json";
    version = "13.0.1";
    sha256 = "0fijg0w6iwap8gvzyjnndds0q4b8anwxxvik7y8vgq97dram4srb";
  })
  (fetchNuGet {
    pname = "ReflectionAnalyzers";
    version = "0.1.22-dev";
    sha256 = "1z0n045wwliycarx81b7w2a7jd228ndpv25yasq8gk5k434fj3rl";
  })
  (fetchNuGet {
    pname = "runtime.native.System";
    version = "4.0.0";
    sha256 = "1ppk69xk59ggacj9n7g6fyxvzmk1g5p4fkijm0d7xqfkig98qrkf";
  })
  (fetchNuGet {
    pname = "runtime.native.System.IO.Compression";
    version = "4.1.0";
    sha256 = "0d720z4lzyfcabmmnvh0bnj76ll7djhji2hmfh3h44sdkjnlkknk";
  })
  (fetchNuGet {
    pname = "stdole";
    version = "7.0.3302";
    sha256 = "1n8vbzlgyklazriwvb6kjyw5w0m9a1b3xsa0f0v29j03z23fx69p";
  })
  (fetchNuGet {
    pname = "System.AppContext";
    version = "4.1.0";
    sha256 = "0fv3cma1jp4vgj7a8hqc9n7hr1f1kjp541s6z0q1r6nazb4iz9mz";
  })
  (fetchNuGet {
    pname = "System.Buffers";
    version = "4.5.1";
    sha256 = "04kb1mdrlcixj9zh1xdi5as0k0qi8byr5mi3p3jcxx72qz93s2y3";
  })
  (fetchNuGet {
    pname = "System.Collections";
    version = "4.0.11";
    sha256 = "1ga40f5lrwldiyw6vy67d0sg7jd7ww6kgwbksm19wrvq9hr0bsm6";
  })
  (fetchNuGet {
    pname = "System.Collections.Concurrent";
    version = "4.0.12";
    sha256 = "07y08kvrzpak873pmyxs129g1ch8l27zmg51pcyj2jvq03n0r0fc";
  })
  (fetchNuGet {
    pname = "System.Collections.Immutable";
    version = "1.2.0";
    sha256 = "1jm4pc666yiy7af1mcf7766v710gp0h40p228ghj6bavx7xfa38m";
  })
  (fetchNuGet {
    pname = "System.Collections.Immutable";
    version = "5.0.0";
    sha256 = "1kvcllagxz2q92g81zkz81djkn2lid25ayjfgjalncyc68i15p0r";
  })
  (fetchNuGet {
    pname = "System.Collections.NonGeneric";
    version = "4.0.1";
    sha256 = "19994r5y5bpdhj7di6w047apvil8lh06lh2c2yv9zc4fc5g9bl4d";
  })
  (fetchNuGet {
    pname = "System.Console";
    version = "4.0.0";
    sha256 = "0ynxqbc3z1nwbrc11hkkpw9skw116z4y9wjzn7id49p9yi7mzmlf";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.Contracts";
    version = "4.0.1";
    sha256 = "0y6dkd9n5k98vzhc3w14r2pbhf10qjn2axpghpmfr6rlxx9qrb9j";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.Debug";
    version = "4.0.11";
    sha256 = "0gmjghrqmlgzxivd2xl50ncbglb7ljzb66rlx8ws6dv8jm0d5siz";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.FileVersionInfo";
    version = "4.0.0";
    sha256 = "1s5vxhy7i09bmw51kxqaiz9zaj9am8wsjyz13j85sp23z267hbv3";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.Process";
    version = "4.1.0";
    sha256 = "061lrcs7xribrmq7kab908lww6kn2xn1w3rdc41q189y0jibl19s";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.TraceSource";
    version = "4.0.0";
    sha256 = "1mc7r72xznczzf6mz62dm8xhdi14if1h8qgx353xvhz89qyxsa3h";
  })
  (fetchNuGet {
    pname = "System.Diagnostics.Tracing";
    version = "4.1.0";
    sha256 = "1d2r76v1x610x61ahfpigda89gd13qydz6vbwzhpqlyvq8jj6394";
  })
  (fetchNuGet {
    pname = "System.Dynamic.Runtime";
    version = "4.0.11";
    sha256 = "1pla2dx8gkidf7xkciig6nifdsb494axjvzvann8g2lp3dbqasm9";
  })
  (fetchNuGet {
    pname = "System.Globalization";
    version = "4.0.11";
    sha256 = "070c5jbas2v7smm660zaf1gh0489xanjqymkvafcs4f8cdrs1d5d";
  })
  (fetchNuGet {
    pname = "System.IO";
    version = "4.1.0";
    sha256 = "1g0yb8p11vfd0kbkyzlfsbsp5z44lwsvyc0h3dpw6vqnbi035ajp";
  })
  (fetchNuGet {
    pname = "System.IO.Compression";
    version = "4.1.0";
    sha256 = "0iym7s3jkl8n0vzm3jd6xqg9zjjjqni05x45dwxyjr2dy88hlgji";
  })
  (fetchNuGet {
    pname = "System.IO.FileSystem";
    version = "4.0.1";
    sha256 = "0kgfpw6w4djqra3w5crrg8xivbanh1w9dh3qapb28q060wb9flp1";
  })
  (fetchNuGet {
    pname = "System.IO.FileSystem.Primitives";
    version = "4.0.1";
    sha256 = "1s0mniajj3lvbyf7vfb5shp4ink5yibsx945k6lvxa96r8la1612";
  })
  (fetchNuGet {
    pname = "System.IO.Pipes";
    version = "4.0.0";
    sha256 = "0fxfvcf55s9q8zsykwh8dkq2xb5jcqnml2ycq8srfry2l07h18za";
  })
  (fetchNuGet {
    pname = "System.Linq";
    version = "4.1.0";
    sha256 = "1ppg83svb39hj4hpp5k7kcryzrf3sfnm08vxd5sm2drrijsla2k5";
  })
  (fetchNuGet {
    pname = "System.Linq.Expressions";
    version = "4.1.0";
    sha256 = "1gpdxl6ip06cnab7n3zlcg6mqp7kknf73s8wjinzi4p0apw82fpg";
  })
  (fetchNuGet {
    pname = "System.Linq.Parallel";
    version = "4.0.1";
    sha256 = "0i33x9f4h3yq26yvv6xnq4b0v51rl5z8v1bm7vk972h5lvf4apad";
  })
  (fetchNuGet {
    pname = "System.Memory";
    version = "4.5.4";
    sha256 = "14gbbs22mcxwggn0fcfs1b062521azb9fbb7c113x0mq6dzq9h6y";
  })
  (fetchNuGet {
    pname = "System.Net.Primitives";
    version = "4.0.11";
    sha256 = "10xzzaynkzkakp7jai1ik3r805zrqjxiz7vcagchyxs2v26a516r";
  })
  (fetchNuGet {
    pname = "System.Net.Sockets";
    version = "4.1.0";
    sha256 = "1385fvh8h29da5hh58jm1v78fzi9fi5vj93vhlm2kvqpfahvpqls";
  })
  (fetchNuGet {
    pname = "System.Numerics.Vectors";
    version = "4.4.0";
    sha256 = "0rdvma399070b0i46c4qq1h2yvjj3k013sqzkilz4bz5cwmx1rba";
  })
  (fetchNuGet {
    pname = "System.ObjectModel";
    version = "4.0.12";
    sha256 = "1sybkfi60a4588xn34nd9a58png36i0xr4y4v4kqpg8wlvy5krrj";
  })
  (fetchNuGet {
    pname = "System.Reflection";
    version = "4.1.0";
    sha256 = "1js89429pfw79mxvbzp8p3q93il6rdff332hddhzi5wqglc4gml9";
  })
  (fetchNuGet {
    pname = "System.Reflection.Emit";
    version = "4.0.1";
    sha256 = "0ydqcsvh6smi41gyaakglnv252625hf29f7kywy2c70nhii2ylqp";
  })
  (fetchNuGet {
    pname = "System.Reflection.Emit.ILGeneration";
    version = "4.0.1";
    sha256 = "1pcd2ig6bg144y10w7yxgc9d22r7c7ww7qn1frdfwgxr24j9wvv0";
  })
  (fetchNuGet {
    pname = "System.Reflection.Emit.Lightweight";
    version = "4.0.1";
    sha256 = "1s4b043zdbx9k39lfhvsk68msv1nxbidhkq6nbm27q7sf8xcsnxr";
  })
  (fetchNuGet {
    pname = "System.Reflection.Extensions";
    version = "4.0.1";
    sha256 = "0m7wqwq0zqq9gbpiqvgk3sr92cbrw7cp3xn53xvw7zj6rz6fdirn";
  })
  (fetchNuGet {
    pname = "System.Reflection.Metadata";
    version = "1.3.0";
    sha256 = "1y5m6kryhjpqqm2g3h3b6bzig13wkiw954x3b7icqjm6xypm1x3b";
  })
  (fetchNuGet {
    pname = "System.Reflection.Metadata";
    version = "5.0.0";
    sha256 = "17qsl5nanlqk9iz0l5wijdn6ka632fs1m1fvx18dfgswm258r3ss";
  })
  (fetchNuGet {
    pname = "System.Reflection.Primitives";
    version = "4.0.1";
    sha256 = "1bangaabhsl4k9fg8khn83wm6yial8ik1sza7401621jc6jrym28";
  })
  (fetchNuGet {
    pname = "System.Reflection.TypeExtensions";
    version = "4.1.0";
    sha256 = "1bjli8a7sc7jlxqgcagl9nh8axzfl11f4ld3rjqsyxc516iijij7";
  })
  (fetchNuGet {
    pname = "System.Resources.ResourceManager";
    version = "4.0.1";
    sha256 = "0b4i7mncaf8cnai85jv3wnw6hps140cxz8vylv2bik6wyzgvz7bi";
  })
  (fetchNuGet {
    pname = "System.Runtime";
    version = "4.1.0";
    sha256 = "02hdkgk13rvsd6r9yafbwzss8kr55wnj8d5c7xjnp8gqrwc8sn0m";
  })
  (fetchNuGet {
    pname = "System.Runtime.CompilerServices.Unsafe";
    version = "4.7.1";
    sha256 = "119br3pd85lq8zcgh4f60jzmv1g976q1kdgi3hvqdlhfbw6siz2j";
  })
  (fetchNuGet {
    pname = "System.Runtime.CompilerServices.Unsafe";
    version = "5.0.0";
    sha256 = "02k25ivn50dmqx5jn8hawwmz24yf0454fjd823qk6lygj9513q4x";
  })
  (fetchNuGet {
    pname = "System.Runtime.Extensions";
    version = "4.1.0";
    sha256 = "0rw4rm4vsm3h3szxp9iijc3ksyviwsv6f63dng3vhqyg4vjdkc2z";
  })
  (fetchNuGet {
    pname = "System.Runtime.Handles";
    version = "4.0.1";
    sha256 = "1g0zrdi5508v49pfm3iii2hn6nm00bgvfpjq1zxknfjrxxa20r4g";
  })
  (fetchNuGet {
    pname = "System.Runtime.InteropServices";
    version = "4.1.0";
    sha256 = "01kxqppx3dr3b6b286xafqilv4s2n0gqvfgzfd4z943ga9i81is1";
  })
  (fetchNuGet {
    pname = "System.Runtime.InteropServices.RuntimeInformation";
    version = "4.0.0";
    sha256 = "0glmvarf3jz5xh22iy3w9v3wyragcm4hfdr17v90vs7vcrm7fgp6";
  })
  (fetchNuGet {
    pname = "System.Runtime.Loader";
    version = "4.0.0";
    sha256 = "0lpfi3psqcp6zxsjk2qyahal7zaawviimc8lhrlswhip2mx7ykl0";
  })
  (fetchNuGet {
    pname = "System.Security.AccessControl";
    version = "5.0.0";
    sha256 = "17n3lrrl6vahkqmhlpn3w20afgz09n7i6rv0r3qypngwi7wqdr5r";
  })
  (fetchNuGet {
    pname = "System.Security.Principal";
    version = "4.0.1";
    sha256 = "1nbzdfqvzzbgsfdd5qsh94d7dbg2v4sw0yx6himyn52zf8z6007p";
  })
  (fetchNuGet {
    pname = "System.Security.Principal.Windows";
    version = "5.0.0";
    sha256 = "1mpk7xj76lxgz97a5yg93wi8lj0l8p157a5d50mmjy3gbz1904q8";
  })
  (fetchNuGet {
    pname = "System.Text.Encoding";
    version = "4.0.11";
    sha256 = "1dyqv0hijg265dwxg6l7aiv74102d6xjiwplh2ar1ly6xfaa4iiw";
  })
  (fetchNuGet {
    pname = "System.Text.Encoding.CodePages";
    version = "4.5.1";
    sha256 = "1z21qyfs6sg76rp68qdx0c9iy57naan89pg7p6i3qpj8kyzn921w";
  })
  (fetchNuGet {
    pname = "System.Text.Encoding.Extensions";
    version = "4.0.11";
    sha256 = "08nsfrpiwsg9x5ml4xyl3zyvjfdi4mvbqf93kjdh11j4fwkznizs";
  })
  (fetchNuGet {
    pname = "System.Text.RegularExpressions";
    version = "4.1.0";
    sha256 = "1mw7vfkkyd04yn2fbhm38msk7dz2xwvib14ygjsb8dq2lcvr18y7";
  })
  (fetchNuGet {
    pname = "System.Threading";
    version = "4.0.11";
    sha256 = "19x946h926bzvbsgj28csn46gak2crv2skpwsx80hbgazmkgb1ls";
  })
  (fetchNuGet {
    pname = "System.Threading.Overlapped";
    version = "4.0.1";
    sha256 = "0fi79az3vmqdp9mv3wh2phblfjls89zlj6p9nc3i9f6wmfarj188";
  })
  (fetchNuGet {
    pname = "System.Threading.Tasks";
    version = "4.0.11";
    sha256 = "0nr1r41rak82qfa5m0lhk9mp0k93bvfd7bbd9sdzwx9mb36g28p5";
  })
  (fetchNuGet {
    pname = "System.Threading.Tasks.Dataflow";
    version = "4.6.0";
    sha256 = "0a1davr71wssyn4z1hr75lk82wqa0daz0vfwkmg1fm3kckfd72k1";
  })
  (fetchNuGet {
    pname = "System.Threading.Tasks.Extensions";
    version = "4.0.0";
    sha256 = "1cb51z062mvc2i8blpzmpn9d9mm4y307xrwi65di8ri18cz5r1zr";
  })
  (fetchNuGet {
    pname = "System.Threading.Tasks.Extensions";
    version = "4.5.4";
    sha256 = "0y6ncasgfcgnjrhynaf0lwpkpkmv4a07sswwkwbwb5h7riisj153";
  })
  (fetchNuGet {
    pname = "System.Threading.Thread";
    version = "4.0.0";
    sha256 = "1gxxm5fl36pjjpnx1k688dcw8m9l7nmf802nxis6swdaw8k54jzc";
  })
  (fetchNuGet {
    pname = "System.Threading.ThreadPool";
    version = "4.0.10";
    sha256 = "0fdr61yjcxh5imvyf93n2m3n5g9pp54bnw2l1d2rdl9z6dd31ypx";
  })
  (fetchNuGet {
    pname = "System.Xml.ReaderWriter";
    version = "4.0.11";
    sha256 = "0c6ky1jk5ada9m94wcadih98l6k1fvf6vi7vhn1msjixaha419l5";
  })
  (fetchNuGet {
    pname = "System.Xml.XmlDocument";
    version = "4.0.1";
    sha256 = "0ihsnkvyc76r4dcky7v3ansnbyqjzkbyyia0ir5zvqirzan0bnl1";
  })
  (fetchNuGet {
    pname = "System.Xml.XPath";
    version = "4.0.1";
    sha256 = "0fjqgb6y66d72d5n8qq1h213d9nv2vi8mpv8p28j3m9rccmsh04m";
  })
  (fetchNuGet {
    pname = "System.Xml.XPath.XmlDocument";
    version = "4.0.1";
    sha256 = "0l7yljgif41iv5g56l3nxy97hzzgck2a7rhnfnljhx9b0ry41bvc";
  })
]
