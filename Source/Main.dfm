object MainFrm: TMainFrm
  Left = 381
  Height = 634
  Top = 166
  Width = 1057
  Caption = 'LDAP Admin'
  ClientHeight = 634
  ClientWidth = 1057
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  KeyPreview = True
  Menu = MainMenu
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  Position = poDefault
  LCLVersion = '2.3.0.0'
  object TreeSplitter: TSplitter
    Left = 257
    Height = 549
    Top = 30
    Width = 5
    Beveled = True
  end
  object ToolBar: TToolBar
    Left = 0
    Height = 30
    Top = 0
    Width = 1057
    AutoSize = True
    BorderWidth = 1
    ButtonHeight = 28
    ButtonWidth = 28
    Caption = 'LagerToolBar'
    Images = ImageList
    Indent = 4
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object ConnectBtn: TToolButton
      Left = 4
      Top = 2
      Action = ActConnect
    end
    object DisconnectBtn: TToolButton
      Left = 32
      Top = 2
      Action = ActDisconnect
    end
    object ToolButton6: TToolButton
      Left = 60
      Height = 28
      Top = 2
      Caption = 'ToolButton6'
      ImageIndex = 7
      Style = tbsSeparator
    end
    object EditBtn: TToolButton
      Left = 68
      Top = 2
      Action = ActEditEntry
    end
    object PropertiesBtn: TToolButton
      Left = 96
      Top = 2
      Action = ActProperties
    end
    object DeleteBtn: TToolButton
      Left = 124
      Top = 2
      Action = ActDeleteEntry
    end
    object SearchBtn: TToolButton
      Left = 152
      Top = 2
      Action = ActSearch
    end
    object ModifyBtn: TToolButton
      Left = 180
      Top = 2
      Action = ActModifySet
    end
    object ToolButton2: TToolButton
      Left = 208
      Height = 28
      Top = 2
      Caption = 'ToolButton2'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object BookmarkBtn: TToolButton
      Left = 216
      Top = 2
      Action = ActBookmark
    end
    object UndoBtn: TToolButton
      Left = 244
      Hint = 'Backward'
      Top = 2
      ImageIndex = 36
      OnClick = UndoBtnClick
    end
    object RedoBtn: TToolButton
      Left = 272
      Hint = 'Forward'
      Top = 2
      ImageIndex = 37
      OnClick = RedoBtnClick
    end
    object RefreshBtn: TToolButton
      Left = 300
      Top = 2
      Action = ActRefresh
    end
    object SchemaBtn: TToolButton
      Left = 328
      Top = 2
      Action = ActSchema
    end
    object ToolButton1: TToolButton
      Left = 356
      Height = 28
      Top = 2
      Caption = 'ToolButton1'
      ImageIndex = 19
      Style = tbsSeparator
    end
    object ExitBtn: TToolButton
      Left = 364
      Top = 2
      Action = ActExit
      ImageIndex = 18
    end
  end
  object ListViewPanel: TPanel
    Left = 262
    Height = 549
    Top = 30
    Width = 795
    Align = alClient
    BevelOuter = bvNone
    ClientHeight = 549
    ClientWidth = 795
    ParentBackground = False
    TabOrder = 2
    object ViewSplitter: TSplitter
      Cursor = crVSplit
      Left = 0
      Height = 3
      Top = 182
      Width = 795
      Align = alTop
      Beveled = True
      ResizeAnchor = akTop
    end
    object ValueListView: TListView
      Left = 0
      Height = 182
      Top = 0
      Width = 795
      Align = alTop
      Columns = <      
        item
          Caption = 'Attribute'
          Width = 120
        end      
        item
          Caption = 'Value'
          Width = 460
        end      
        item
          Caption = 'Type'
        end      
        item
          Alignment = taRightJustify
          Caption = 'Size'
          Width = 161
        end>
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'DejaVu Sans'
      ParentFont = False
      ParentShowHint = False
      PopupMenu = ListPopup
      ReadOnly = True
      RowSelect = True
      ScrollBars = ssAutoVertical
      ShowHint = True
      SortType = stText
      TabOrder = 0
      ViewStyle = vsReport
      OnAdvancedCustomDrawItem = ValueListViewAdvancedCustomDrawItem
      OnAdvancedCustomDrawSubItem = ValueListViewAdvancedCustomDrawSubItem
    end
    object EntryListView: TListView
      Left = 0
      Height = 364
      Top = 185
      Width = 795
      Align = alClient
      Columns = <>
      DragMode = dmAutomatic
      HideSelection = False
      LargeImages = ImageList
      MultiSelect = True
      ScrollBars = ssAutoBoth
      SmallImages = ImageList
      TabOrder = 1
      Visible = False
      OnDblClick = EntryListViewDblClick
      OnDragDrop = LDAPTreeDragDrop
      OnEndDrag = LDAPTreeEndDrag
      OnStartDrag = LDAPTreeStartDrag
    end
  end
  object TreeViewPanel: TPanel
    Left = 0
    Height = 549
    Top = 30
    Width = 257
    Align = alLeft
    BevelOuter = bvNone
    ClientHeight = 549
    ClientWidth = 257
    ParentBackground = False
    TabOrder = 3
    object LDAPTree: TTreeView
      Left = 0
      Height = 510
      Top = 0
      Width = 257
      Align = alClient
      DragMode = dmAutomatic
      ExpandSignType = tvestPlusMinus
      HideSelection = False
      Images = ImageList
      Indent = 23
      ScrollBars = ssAutoVertical
      TabOrder = 0
      OnChange = LDAPTreeChange
      OnContextPopup = LDAPTreeContextPopup
      OnDblClick = LDAPTreeDblClick
      OnDeletion = LDAPTreeDeletion
      OnDragDrop = LDAPTreeDragDrop
      OnDragOver = LDAPTreeDragOver
      OnEdited = LDAPTreeEdited
      OnEndDrag = LDAPTreeEndDrag
      OnExpanding = LDAPTreeExpanding
      OnStartDrag = LDAPTreeStartDrag
      Options = [tvoAutoItemHeight, tvoKeepCollapsedNodes, tvoShowButtons, tvoShowLines, tvoShowRoot, tvoToolTips, tvoThemedDraw]
    end
    object SearchPanel: TPanel
      Left = 0
      Height = 39
      Top = 510
      Width = 257
      Align = alBottom
      BevelOuter = bvNone
      ClientHeight = 39
      ClientWidth = 257
      ParentBackground = False
      TabOrder = 1
      Visible = False
      object Label1: TLabel
        Left = 8
        Height = 13
        Top = 12
        Width = 52
        Caption = 'Search for:'
        ParentColor = False
      end
      object edSearch: TEdit
        Left = 64
        Height = 21
        Top = 8
        Width = 177
        Anchors = [akTop, akLeft, akRight]
        OnChange = edSearchChange
        OnExit = edSearchExit
        OnKeyPress = edSearchKeyPress
        TabOrder = 0
      end
    end
  end
  object TabControl1: TTabControl
    Left = 0
    Height = 32
    Top = 579
    Width = 1057
    OnChange = TabControl1Change
    OnChanging = TabControl1Changing
    TabPosition = tpBottom
    Align = alBottom
    TabOrder = 4
  end
  object StatusBar: TStatusBar
    Left = 0
    Height = 23
    Top = 611
    Width = 1057
    Panels = <    
      item
        Width = 170
      end    
      item
        Width = 24
      end    
      item
        Width = 200
      end    
      item
        Width = 500
      end    
      item
        Width = 50
      end>
    SimplePanel = False
    OnDrawPanel = StatusBarDrawPanel
  end
  object ImageList: TImageList
    Left = 328
    Top = 424
    Bitmap = {
      4C7A3200000010000000100000000E2200000000000078DAED5D2DD8ABBAD2AD
      ACACACADACACC4229195582412894522915824128945229158646565BEB50642
      81F2D7EE73CEBDE77E653FB3E90B59339349269940120E87F7E3E89F1449FEB0
      0FAFDF3B0EA6BD95779025B863046C70DCC583698CCA56466D0B8FFBC3173A26
      C0FA47B585356B57598D2B3C285FF338A56775F00EEA700739073587B580655A
      F2D0F86B61A873765507F7A02ECE45D9813DCB837847456FF84B7E13ECD93EAB
      B22E158F388BD5F18EBCD82F1E17EFAA8CD21EE1AF85099D8FEA649F7AAC3E8A
      AA5057F7DAF388E3585DDC8B3A4557E01DC937F33B94DB1E4FF5783CD4F3F954
      5555A98B7DE9F1BCEE448E3A7A27D1F9E4BCE4D68F5AF9B9AFACC4527995AB47
      D3A8BAAA95E5583D5E1F5991293FF1555557FD35620FC141282D53D5005F96A5
      F27DFF0D3F770CF14991A8BAAE555114CAF3BC1E4F9ED383F9C47FCACFA6F86A
      84D73C689329FEF97C282FF37A7C9CC782657AADFF9007EFE9436CFD68F1A700
      7E11DC5410F9825DAAC7BC97E7B960A90FFFD6B4D707C330FC18F3F3FF9FFFFF
      FCFFE7FF5F1F61AE46F421964732A0377E4B7C67B06B749CF2C0DF31AA899537
      BBE84D179CA30ECFA37CAE535CC17774FE3A7CF868F139EEF3F716E5A897437C
      D0FC19DEAF5B7C867BE4B54553BC57B5F81478F2DAA2EC31C6BB1A0FDEFCBD45
      53BC53B6F80478FEDEA2B4798EEBD2525D5BA3DFF1F3FF9FFFFFFCFF7FF0B827
      8532E25C992037F9DC976F2C67D4C53BEAC309E56206C92E1EB708D852493DAE
      400ECAF38870EA1CD5BB781C935A5D9387BA22FD8D9435EA0CBC91A17EF8D126
      FE1A23A645DA3B9A149B54B467FE6D7ADB780BF2CD54098F2919DE3EF9061A29
      93940E087F1B6EB4CB86D7E8A16E08A70D52D29E6F68A02CDBD987870E97B051
      D790767CC8F9EC06CA76EC7D6518DED4CDB79585B2240569AE8CC8801E86BA87
      F7551E97E0A2DCD2457E4D8C339071C4DE1CB3F06FBFC2F823B39413CEE78358
      3337E1DF8EA4A51E8F27C6194DA1ACD412BEF7E2AEAE186B0DE37E7D9CC333EA
      892169C8C3294089ADC21C792F6C21F2E7386B0E4FF9D7F42A3CACDC6A65613C
      7609CEA2F735BEAA13C656A66DCEE27918BEA12EDE654C18A35DED2BCA0F7977
      9C45AC3E787F8D7EFEFFF3FF6FFCDFB1F7F97F78BB29DFBE8DFC3F320C1583C2
      FBBAFF07978B2A5D5725A6A92AE03AF76FFFC6583BB32C153AF3F9203647BA12
      F799967A3C9B876A8A52A5C0916F01F9DE75DEFFC3F35965D09169C8A30025B0
      591E84AA40DE49E4EF5EE6FD9FF253F0268F1CF2C827C2DFC1F9227AC7947B3A
      29DB5CF67F1F588FFC07649380B5AD7FCEFFFBC309D5C9443B86BC9CEF287FC3
      52E79BB18BC7C50DD511E9AF28070BB6BB3AAE3A78B13A39D1A22F4FDB9DE30D
      F290FEE226DBBEBCD0EE5C6C5F1941B6EACB5BEDCE962F6FB53B5BBEBCD5EE6C
      F9F256BBB3E5CB5BEDCE1E5F5E6B77F6F8F25ADCB1E6CB7BE38E255FFE24EE98
      F3E54FE38EA92F7F1A774C7DF9AF883BA6079FA536752D5497A5AAF25C157CC6
      5A558B783EAB249545A12A5091A6AA48125566B1AA0B501EA9C40F5455CEF3A8
      20274B42C88A200715E8C9713D9F3FC3199E28932652B1EBA922CF17F18F1295
      AE0E957AC42DE699B5E74722D713E43F4FB3597C0DDD1F25D2A10C8547130F28
      94EB79E0A92C9E6FBBC45E05E4A1BC5B1EC18BF837AE9701FA9470B91F2F6133
      546CA4755A3E3D3972BD896C15C3868B65C0E7C629F0A807C24713FF465DA843
      5785EE721DA8516E0FD43D95DD4086D033F75493862A639F0A1F8ABC65F9AC1F
      4DE2B4B8C257759AA8BCEBCF0360932042DD2857F1651CAA3ACB54C5BA13A1CC
      8115A2CF67D922F601FBF39939DF4DF0B93DEB7085F409FC2C465B910581CA60
      7B96D3926CFD6E8467BE63603DCEF92C1DED85E0D17E6449AA96E4B30E6ADF61
      7D6279E4C84702DDC927441F9846CBCFE4CBBC40FD8A259F25883E94E3EF14B2
      038765E72FD6FFA11FB08E05B6AB3CF4D924FF0E1B4077F2DFDBF5D37643AA93
      406CB21B9FA768B3B51F26A843BE8A509E7B79D479D2FA0EFC5E35901DB76D5E
      B5D2068DF1905DA0DE97B65015B89FE1631FAE7F177F68203B443FC4F73D7BF1
      3C585617F43116DA7BCA4ED3F9BA33676BCAD178F6157369B66CADF192EF8534
      4BB60E71EF9A56423EDA9CA5F258B235E51EBC4488BF97CA63CED611F26BC3E7
      743F477F582A0FC97F124B5BC3F6A2F07CC14AFED91775769C4B93C03753FC4D
      7F977792F457FC4D7FCB20936D01F9AFA591FE91BE0A5E24FA6B089DF53B49C9
      DF4A1AF2E5FBBE9CBE8E7B1EF2EEA2BD605DE13D5DC64B69A4ED413AE6957926
      895E337E364DF38BFF7FF1FFDF11FFD3AFF6D0D5F167E37F7D7FED98E287F1BF
      C62ECD2BD0D7357E1AFF0F654F790CFF267E2EFE9FEA3E7C873F3C889F8BFFB7
      F23E95FF16FFE3FA5E3AA0AE1D92AAA5C96FC6838C6118D393661D7D889B9C39
      F7E1C19810ED541560CC87186816AF319ABA6B15DAA992ED7FF73C269DC30F71
      1362EC9931F6E27813947E283FE3780198827D06DAFB742E765FC9BFC8A46C60
      73E2A3685EFF05FB1357407EC59810E764065FA37C584E127B83F89BD7D8DF10
      2FFD1DDB7BFC9EC3B38C243DCB082478967B8727B1AFE3D82946FE238C8122F4
      DD81D7B64111F462CCCDF85770A8BB9A17ED4D9C50081E93F928AED3B6211162
      53F66D0DFA49E181DF25D2265D9965E8BB39EF663A9FC5B95BEA35E725526110
      485E1AAD3F74C9A807F21D4007EA4CF25DF89A6DCD3F47EC64722C96021FE26F
      C61931E27EDFB5157526D6BE9BEBCF328121459DCEC48ACE82B59465DCBE7E87
      689937657E89B7CC49FF7D4AC45E433A60E8C7EBBBFCBF4BCB310F7D5DFFFDEC
      E63E6DF93FD3684CCF8BE328CADEE1FF2283B1CE4067A9CF9C47B5C3FFE7E4EB
      3AB8CBFF07F96F06F917FC1EFF47DA877EDED2F9AFE6F1F3FF9FFFFFEDFEFFA7
      C70D7595F4A7F87F92C75CBA3D3C76DD7FA855FE9BBA3D3B1EAFB15F7BED03FB
      6020D4F3107A7E6EDB1BC6AE428F2FB0B51AE16FF587BAD72FCCF4EF45DC43AD
      A65DE331C4ADC9D9E2BD279F73E9F662BF4DFF77F1F8CDFF9B9DFF374CF3E9FC
      3FFE3D9CC737CDFFD6FC3F9D666EDEDD127E38FF4FFF3D376F4ECB5A9BFF379C
      8F3767BBADF97F5BF3EE7EF3FFFEFAE35164EA51E68B54E719E2577FF9DD4B99
      C93A8B256AAA1231A88F986EFEDD1165AC1DED7B215FA9C253B7A010FA088FB8
      320F5F58D693210F796F377B3CE55DF0B3A9D4DD89941B035BAB371DE6F12D16
      C1B172ED48A5F943D97EAEEE7C4E39D1BF7EC3BFB0F73B62683896E797CA7681
      B7DB587E3C06C866B136D226D953D91EB04EAE2C2B52AACEDEF0558F1FC845DA
      287EA8BB5B28F39E2AEB1EA927B0CF3A7DC76769076FB196C5352EC0DA85B2EC
      14785F3D2B60AB1494BCE14BC13F056B98BE0A9327E431AFC05AF711F659C5EF
      F83411D996E588CEC45AD0D930C758BE1F9EC3178287DEC61DF9465ECD18F48E
      7D94D13C1EE3130C80306633C0C3153E73D8757C05150AD8376FEDACF34B9D89
      93F3BCFE7A9CF609FDA50D888FB1F337A4B1D3F6806FFD3957043F6CF60D68B3
      4D749E66F15006E886B69EF4C6EB03FC107B865FF3CCBE89CFFFD9C739F8ED82
      BC8E782F643F0B3E8249CA1ECFFBFA6F1382D98FC2DDFB33290696B299E69256
      F2B7C6D7ACFA7C9E9BD5239EC4B34FE56F7D9DF9109F7BBEAE310DFFA6EC13F2
      120C786B627E78CF823D284FFAEAEE5ED4B4763A4585D88AF792095197637016
      A21DA2810CDAE992F05D612DF796E6FD136B37A19CFD419E6EC837CBE05EB576
      A72E5AD694EE75803C78F25BE3992FDA9679D3C4FBCE23EA897235D62C1D752B
      EE2D8F85FAABF1539C51D8EA9A5BEA92192FFCDC5CD405FDF760D7787E8B1DEA
      F46FEEFFCBE87DFECADEFEFF9181124B15813BE2B1A7FF2F12F4BB51A8B23078
      1B8B6FF5FFEC1BA47F5878C6A0FBFFF87698A5F07652975B29B82A0D5432998B
      AFFB7FA69D3BEE5E2BB30696B4D4FF13DF40E57AB094364E5BAC73B35595F8AB
      FD3FF1947532D1E6A11D4198AECEF86DE15A847B825FE9FF89AF602AD36D659A
      4EA777D3F2AE126FB5FF1FE6DF8F5BACEDAB5EB72A7657FBFFA9FD425CCE8B1D
      F8AEFF5F2A3F4DEBF8B6FFD765445B31BFC40CE9EFE8FF1F79D4CEEF59A12C58
      9E3746FC96FF13BFE8FFC46FF83FF14BFEDF64E1A6FF13BFE8FF8BF897FF133F
      A491FFA1BC8607D7CB1FC283505517BDFF37F85DE4A98A5D6711AFB15553828A
      8E4726E7363ECCDEF0B4AB3E3456B73B1A2B78C4966A153F69B3906F8D6DF16D
      FC3FC5E761D0C7FFA3F4D0E3597731ED201E9EC7B7F17F6F37A6EDB025E25EE1
      D7C5FF53BCD40DD1BBEEB172064E63CB22ECE3FF797C23F9D53A6BDC10ABE3F7
      777C20B297F23B8DFFE7F089EFEDA629FEAF38D487C748FFFCA9BCF0A1DC0063
      5C0FE33E0FE34717E3A98E4CA725C346DC7E6FD4C5429C18B7CF1EA5AD06364E
      9F686F1FCA8F1E3D2FC76FC9F65B9E9AD7ED8E78D178F5F94C4B6CD06123F062
      DFF3DA87016D39C6852F1DC678F2D772395E967D2C98A7A0D583BF79902FF527
      FE62E683FEB59174BCCF837A685D759E799F07655CA778A4653EA97386185E6C
      E7BC3AE1ABD8AC113DB8CDC5144F39B4BB96AD6D3FC2839C4E07DAFF3CC1330F
      8B787B066FBCF6B9B8D96D7ADA3987FED61BFE013CEC58B47DF91979390DF0D4
      8F3AB08C44079695B69FF310BC17B5B675438C71CC461D6F2F3CF5A19D995E97
      5F5EB6759294775BA0C4B877B41EEA68A09DB9BEF067B3161D340FD685E63168
      CFA133E59F8835F9BE98F897FD4E4685F2000FE8C1BA711DD085758DF9051DA1
      B7606F68572F59EF474154ABD32D03E5522FCF46D69D73F0CE25AF2DE5A237B1
      41349E87FA27FEFB5BFFF75BFFF75BFFF75BFFB774E418F7E67128E3DF4F7069
      80317F8AD8A7C9101E6588C353954781D01696E36CCE29910A5023EE2BB80687
      E324CE6D893779D405C7944D1B8B49DC9508167FE07AB59A17E65741E7671109
      56356CEBEB01350815F3F659C0DCBCFF849814E38D40E2E5214ED313E3BD7C41
      078DA7FC565F8D7D76C4752EE522BEE741D9CF6A801FEC2196AEEF0D5512FF78
      CFB7C453289774E17910DBCAAC429F1B47526738E679E59B7384B245BB11CBB6
      F212D4CAEED6296590538057D1F15BECB3BA76F68CB6CBF21399A3BFB79E124B
      3A072DB6FC006B75D80BDA49628B0FB032072A2EA0F3E363B9231D1CFFA3FCFE
      FAFD7FB8DF47FF394B3BFA7DA6338A5ADDEBA7B2193BA36C48465E8D792CF4FB
      07F3AE2CF823D3DEBBB3DBF199EA30D7EF8BFCBCEEB1D485E7297E69FD2DD398
      6523731F786EF95528A3B2C72FADBFD55886F4D499731728FF92BCF2BFB4FE56
      EBCAF740167868FDA7F69F9B7FAF7524B6CF2768CFBE1F4CC7BCB1B5D3323FD9
      F783E9EB0EABF19FF6FBC33CEEEDF7B9466D4ABBDA2FC4554C3BDC33917B4326
      71B28B8FC6EA359B455E083644DC1570DD23C85A891B898FE3764F48AE6BE25C
      4D1F18AE5FA3DD486B3AF09EC6DE21274E127547ACA7D79FF1BA6118ABF82706
      EE25E24CE2299F38EEC148DDC967CEB6B76E1D157F371860E6592E786268D3A8
      D39FF7C3C05571E4AB34412C9AFAAACE5C74ED76BFB690F6D678BFC353BE962D
      6B801F413B03EAC1B880CF422D75455CC9FB5C939DA559AFFF14FFCC4C34CC2E
      703ECE9EACDF7BA606F27093FBDCCB73159F5CC76B92E1AFCFF822769DCA97FA
      EA7A23FC233C42F533E8D2D115F8AB32114BF37E1446526F04EFFACAF260DFD0
      C4FD4E7E744250C297120EC23A0F3169A87CC8D1E5CA34B43BF12E64DB1ECA3F
      70947D6FED9F21568A511ED3B29BD68316EF8AFEFC9BFA49BF8AEB6D3D8D55E0
      A37C58AEA6A9E67DF0FE565F89A78DB92E887925EDF5CF218F218DFA3F9623F4
      7130DE71A03FF3E00EDF3159684BA634D0398B3DD4BF003E10ABBAE4B35217A1
      E35DE62817DC2FD76A9F0FB37FE7FB5DFEEDDD0E724FEA6765A35E8683FAE94A
      FD24BE41FCCDF41A7B2E5B7C1CB9724FF0A5D5D6CB41FD7CA4A6E083732BBFC7
      E62DFE7E3AC83DC1C7A7B65EA11D57E945EA1AEBA76974FB4B6CE45FC5C71687
      7AFDC86C55269E0A5C5BFCA38FC79157EA2BFA4CCABCCC2295C681CC17771D17
      3853686FF9D08FA58F0096E3F4A1DCADF2D178B61FF43DF2E15CF96BB7B7C656
      F90C7518D2C83E2BE5B3A75FDA2C9F4DFC76F9ACE1B7CA6733BE5C299FBDF8A5
      F2F984C75CF9CC8EBDB9766281369F15E4B94A224FFA51D7B146675ECF37F62F
      D07889099A7C74FE14DF54D9E8BC07CF3C6A7C5DA6A333AF6FD9806BB235BECA
      E3D199D7E7F60018DA37495EF8228B46675E4F66F69FD032D947683B4B7BDBBD
      57D4675D2E53BC96493CD7AB687C1AFBA333AF47337B4A6B9982473FA9F17367
      BDF67C589FB44CE2B98E670DCFFBD2170E6CA965F27A20EBA496F1BCAFF1DA96
      5AA6EC492EEBA496F1BCAFF1DA965A26AF7B6823F4EFE1A131BCAF7FF76B833A
      9982F7C6F8BCB37D8FF75E78C6B86EB7AF0479F137AF0541CB3B95FD43FCFE3E
      AFF33EFFE6395C7866C0799337C31ED1F5BAAFBD23F66216EA6C622C6935CA90
      F72A183F3A18B79EB7DB2CCA32ED4AE67E70EE86E5F2FD12E85EA9F3E5B60B7F
      B330BE449869D82DF68A2EE06695EA723576E12F4629F3562E663B7FE564E0B7
      51A8EB6D3EE6D27121FB65E2CF37D42B743742E8B28ED7A732AD14F7EE127332
      2E1CC6FF3ABECFB358E6AC9A26C61C77CE39AEE53DA0ED56CAB223C1B02DCD63
      7B14FFBFE2FB0C72D0D64629EA693A2A3BD731119BDBB887181863DC61FCDFC7
      F74D847BBED2F12AFB9C61BC9AC60EC61E8E7A16E3F87F18DF3F0B57F01CCFE9
      75FC3A5E8D7C5335A9F916FF8FE27BE8D224A69AC6ABAE7556917B858AEFF1FF
      5B7C0F3BB2AFA47E24FF0EAC67A832BE43FF71FCBF15DF53461C05B2B67029FE
      DF8AEFF7DC5F8BEFF7C4FF6BF1FD9EFBB37D9979F8FA9922B1957F51DFF010AC
      7706FE8C62FD0C4F6CE99E54155C457EE99E45873D7A68B90DC6D79CCBD124F7
      968773DAC48B5CE708B93755C34FAAF0AE0AD4D7FC7E142AEC13E88810F8BD0D
      631EDBFB2047137919AA8E4C9C2F42B57752AE817A737AAD1FC8ACA3E491B273
      E0A9AFE41DE965BE1048DBA2E1B3B22BC60D47CEBD60DFD7B6FF945F83470379
      E451872DBE491D99C35247B75607D8A670CECAB8F01D1CFBAED7F378D6E702F9
      649A9ABAA2ECA82FCF5296823D41D70BC67EB70EFBC273BF98066324F24FEC8B
      8AEEF05BF0B4D1E69A17F44767B47727571D0F41A7F7F85DC0D545DB890EE374
      CFD4D12CDBB58767AEA37E76F965DC977434F71E215461522A2B68D4D100E644
      EC0358F03A666D7E8FE902B63D4EA756AF342D94E395EA74613965AD4CE1B1F7
      FD59D8F1C910EFA71F62DFF97C87FD602961B71EE6531AE2A7F3189EA3B75DAF
      6BFCCDE7FA7378BF52CA2F5BF22634BC66A4EF789987548DD3C93A7C12CACFDB
      839FC824F6E68CF12E92DE929DF8BEBE6EE3699B2196E94807FF20E7E1B545F9
      D3FC03ABE993FC4F71FAF739BBEDD29FE98CDAE9759FFEBD851FCAD73618FE3D
      877FA877DB697226BFE7F0AC93B48BD826D94113FC9FF8CFDF70A819FA6A2AA1
      EC5BD68EB9D527D8A1EC0F78F4D8381CCDF15DBAFE5F81EFAEEDA6191EBBE77D
      15ED9C8159FD786F8B9C76FECD0F3FC1EB7B7B688AFFA6FC37EAE1AF3DD8E98F
      FF69FC27653FE031C27DE3F7833AB4ABEE2FD4FBC30FBFDFF7E7F09F96FF3FEC
      F7FFF90363C99EFE14FF0D0F8E999B406896C794FF0C69FC2C8F0FF126E7A70C
      7974BF832619D10833C06A9ACAD883310BB3A7BF04BF37FF73723F29BF11F6C3
      E75153FC3F5D7FFF2547641ABBFAA16866FF315EE39CEB3D07D34D790CF17C4E
      BA447BF0FF76F9DFE2B3FB5D15DCDF9CDFC14D125577C47DB38552FCCD7DF956
      E4F7E479EDBE8D9C73CFBF719639F5B6BD88AFBAFBB297E0F0FB13FCCDBDFCAB
      4AE6D3732EFD169EE9489CD7D5348F1ECF39FEA969EEC6CB5EFEC0D7DDF78A43
      CEF15FC27779A5CE637C033D347E5EBEE621E500FB2F5174BBCD62FF9B8EB20C
      616BAEBBE437889DEE37DFBBA3EC32D485D217F2BCF77781417056A434355518
      F24C32F0FB80F437F5E0773D540E3E7CD776987C7BF9A648697A457A1376CFE4
      7D58D3C482B76DC44FF1113CEEC0DF46F8E73312BE3CE7B9D7A53DA32C2DE86F
      43A7A35C0BF8FDE7F82474BFBFF055D5EE2EF67C8692E695F688BC1AF2DBB2DA
      EB9AC6F8007AD9D0F5D6E3A99F26E69DFA91F2FC75FF657357B0757D44DA0362
      CD83E4B928BCEEF74DF2F67CD216C7377C1C5B62B72439AB2832BBEFAEE4627B
      AD03F3D234568F1FEB4FDE1EF26002435981D839494E3D9EF98AA293E8475B8C
      F5F7C0DB80FE27602E82ADEB33641E247D1018522F1CE7DCDB6FACBF01DC51D2
      533FCAD558EAC6FC34884558A734DE1FF851ABBF2F72A9BF52A19407ED811E4B
      F2561457C903F3ED4F7C90F599D8A6A10DAF48DF96076DA6ED92E727C1BB3373
      07E3D8ECEA3AF37A42FDBCE2F751D2B7BF4FB01DF263FCF7FAFE23EFE66DCB3A
      EC47BFFFAF26EE1151C5CB6B761E8B7B70B4877CF3220D5493BA0B7B08ACE19F
      ADFC04F5126D10BF2331C5374BF867BB26BE298B6E0F10EE031C2CE2E5FB31E8
      6B9E68EF49F2BBAE702EE49D625D662A9F597BC36FDEB44BE8B9DF00D72DD542
      0FEECDCB3D8C415CD3C4F54C5C47B507FFE0BECD5C3787BE3D71D1F6E671BFB7
      D414CF3D775B7C279BDFC3219EFB45F05B199E2BF3E0F49AF6593CF24ED98F0E
      DBF03B36FC7E0EE755FBFC7E4FD8AF877FEB3792760F8F4753A914F146D1ED21
      CC7D8F23CEC38E7D5C7BADC39FE28B3891FD03B8AEAA81AD8B2C51691C41AEAF
      028FDFDD41BF93ADE1F51E1C65BF0F17EDCC3C17DC932307B688FA75FC73F8E7
      60FF006D677E536AB8FE7F1D5FCEEEFFB5072F7B3DC36E5CB755C69AC2457AF9
      4DD4EF393224EE89F0CCB6D77C2EED9DD1EEB78176305E9F3754BFE1DBB77EA3
      FD36FC956F56A5E11B56EA91FE7E13E73AADAC5D659B30DAFB82D80F6CD2EE9D
      F194B9023D7D609302ED492BB7E9F7DDF8C42679E80B7628FF139B707D5DBB3F
      49052AB9598A9AB349AB9F4E57F5F854F0D548FEAC4D0644193D1EF9E0DFAAE1
      E600B9D09C4D44EE209DC6CFED8F316793917CF8D75A9D98B3C94BBF4CD655AE
      E1E76C32925F6DE0676C2272B9368AB126680DBF670F9170CF7AEEDFF77FFED5
      DFFF996BC7E85BBA0DD1756069FDE16C3BD6F9FFB00D101E33EB0FD7DA81611B
      A07598AE3F7C6F07E6DB0029C399F5876BEDC0B00D585A7FF8DE0EBCB7016BDF
      FF5C6B07741BB0F6FDCFF776E0BD0D58FBFEE7B76D8053B8A8C3B79EEC7CDFDE
      0FFC56A905F901C6DC240F63FF3B6D827C9D3887235B6E3B28C7C338386E52C1
      D975A00C9409B19A2EF95D9D30F69E934B2C656A1C7F331627BF210FE1138D9F
      C5B6B25FBAF277FF9DA9267FC39F31460EB2760C405B519ED67588AD510FE6F2
      2014B6F300C5C6DDBD2156CBA6FE43D2F8837F1CE1A9FB9E436C088CB6E30D63
      E739F9DA7643A24D050BD2F25937C8738E07F5D7FA6A1CE9989DE57BB6DAFEB4
      E7D03E431E943BC491A8BB19BEC670CC436FD78E581FB40E1AA7E9E01EDFEAD0
      D93FBFE97AADAC915CC13A18A327F3E3D88B7F11DDA618C1C50791BB84ED9F81
      E13EF9888E24C83BDB67FDFEF01F39FEEDFEAFD3CFF9FE1EFF27E575DEFBF027
      FEAF89BCE843531E6BFE3F25EA3F6C4B86F8A9FF33DF5B07792CF9FF1E3C7D69
      CBFFC73E18CF62B7FC7F09FB89FF33AF7FE2FF2C57D6A937ECFF03FFDF391F61
      7BDECB70BFB1F13C9EDDF385267B96ED9A337498CAFC67B06FF93E4CE62D6DD8
      EE8599F2D8A7C7BB9CEFF2D0DBE1F01D769C97CFE78D8D657F5106531B7CA1FF
      E10FB1872FE6C90DDE83057F22F7F087D8DFF8FFF7FDDF3FFAFEEF54D73D7BF9
      CD8DFF29CB76ECD5BDFCFAE7A89CBFC07576135DF94E9F7BF04DF7F2635AEEE5
      27CFCB3A9D788D32B4B2FA3AE551DFB9BDFC9886FC743ACD83E37F8DD7F9E59A
      C4E95E7E1A2F732388EF74D3384D76B76FE1742FBF39BCD651DBD8EEF4FD76FF
      BFFFE8713F7DADF3D94479E1DFE90B1E1A6B17FCE603EAA97354DF606FD55DC8
      2E3DE8B1E3BB0DD6FD0DDB92A52E29EABBBBDCB64FE55E4B127085A9AE20E2CF
      C1096DEA3B8F399DCF85817614B17E7651578E87293F38A823E864BDCFDFB820
      7F1A4FDC31BBAA637A133A27DDDC3BD24A1E4EF70B7878CAE0B82233D521052E
      85DD3CC4C11E62F43D364459993296003E39C91EDEC7F024B1F4DE323C3A2779
      1677C4388774B2BE98BF67439E7714DDBFAEC3D6EDFFD77CDF69207339AB3FC1
      2AEE21FA058F1ECBBD4043D0757FF9BF614971041EDB7AA8DBF51DAB8973FC56
      F478971BB4C4E7D024F4A58AF3346778CCEACCE7CF9EDBE2D0B72817F2CD1B3A
      F7DB6C5E8487C67B5D7A12F5260F436357F2807B622BEEA9AF65DB772576316F
      FB6C78EDF4A0FE77ABCDB3657E540F440FF2109DAFDFD721626FDFCFFDFDA4DE
      FDA70EEEE3521485EC4FB0747FE95E3BFF2996B99AE4114EBED1CD7B9CBBA9F1
      FC3B99DDC3A6DB6B82FB9A0C7868DEB2470EBF070D5D96F600228E698889BABD
      5178E6DC4DEA4022AFB5BC681E24FED6B6215187388E37CB53F3E0FA6FEA9A65
      B9EC7BB37B2E76B7C70B651B51A9AEC1BEBD5C89A37E94497D23EE019B3ED087
      36E8B7ABCD7D93681B12ED451E01743E739D2AC643077EFB8CDF7C98E1C3BC12
      470CB1BABC5E0601A678AA03BF7D96F21B21631EB2CF4D57A6E445DDDFCA18E3
      B29E47FE18E9417BEB3AC3B3CC359EEE8DE365B043C7030345E13729333D765F
      DC9BCFC0B82B2EDB3C38F1777E4D1EDF62FFCEE3F7FDDFFEFBBF6BB4F5FD5FCB
      AAD1E5419659A3CBABD0FC57E8464A753EE7EA74CE84D6BEFF6BDF6B749BFCF6
      670D1E1570A932CD521946D1D3DAF77FBFC10FBFFF7B87FE2EF1E063220F73F8
      B5EFFF32DF94EFF09B24FCCE08F26B420FD32817F1BFEFFFFEFCFF7FC5FFF577
      BFD768CDFFBFC10FFD9FBCB668CDFFE57E170B6ACA8A5C6878CDD3DF6F98F87F
      8E748C41F8EE5413FF5EBA36F57FF6C38FC743CE3A561C12AF0DD34CEB2EF72F
      66FCC133EF0F6592786D98665A1DB9071CE307B7DBA775BA06585FD769DE1E5D
      74E9785FAF5B5ABB36FBC86CB2D7D712FDFCFFEFF77F0EE1F43EE65392F7342B
      FEAFB14BEF4219E7AEF97F8FE5FB384DD377726BFEBF227B68BFA1FF0FBFF7BB
      21FF30E7FFFCAD692BFF7BFAFFBD799894EB6299ED7C173D2B7754EE7FF01E3E
      F8ABDEEFFD8EFFFAC79FAB6DC70EEC6ADBB1C26357DBB107FFDD1C8EC3AEB6E3
      0FF2FF910E9FE17F6DC7EFF8AF3AF84D4CBED62665B9FA6C3FD5B47D1CCFFD8B
      4D3346CC592A5EDB83F51CC4012EEAAE87D82B6EF73FE0B34CCB2C54E86DF308
      1CBE0228D4DD2C15B7E0CEB3BAE351A8C0D9C6DB06F763E0B344C8342AE5F1F3
      23451BA7F1EFCD77806872E2B89519C7A93A1DCBEEB540A38E873D36A8D5E9C4
      3DAFBAEF8987DCC7B3EE9AB3E7CE72280563590D627662A977F351199E4E61B7
      8F24F270DAF13DADE0AC86F46DBDFB2BF95C32E36B1EC45D33535D736B99C7C6
      388338B372E6F1B3E3974C99A8AF9A88B36A5FDDF2FB98C7CAF8656ABF3BF7D3
      29DDB14DBBF1CB1289DEC0D84D28E43C22D98BA7D7A11BBF904E51313BE612D9
      D07D841DDCE758C3AB9FEA12178BCF4088E13B7D9EE9519C67A5F11C6BD0460E
      7C335D79862136CCEBF67B60E56B2CC6B1C619B263E8106D3CBBD0F8E9F30B9E
      A7E39739A29EE904CFB187915632FE188E5FE6C8003EE077BD06F84B82B60979
      0FAAED6797465ABFD7CFFF91E7974BDF1AD9FA0689BC63CB12D5C4375527B6C4
      B6FA3D9FC6E8775AC36B1A5B16A97AC45754D4003CAEF26C48F684EBDED9F19D
      949ECB2FDF1391EF94B57C789F6BE69B181D43190A9ECF67F4F7CCF4FBCB215E
      BE91D6BDE34A930E1FB5F83ABAF6F2B6F0F28E304E045F4767E07D9C2FFBF17C
      3E26CFD51EAA0ED151959EAA3EC0C7512C447C1574F8703F5EDE378691ECB953
      0547C97F091FE7DEFC69F71E2FEEBE63C17C728F7E126D46FB477C4F1AC4C2A3
      F48FB25EBEF4B9C74EAC721B18BF7DD6977AB8EE64AAB673A102BF792F0E2255
      199910F1A4C23FA9F81AA8E296F6F7D648D7C102D8CBE9A032EFF4AF8AAFFF0F
      C5E398B6
    }
  end
  object MainMenu: TMainMenu
    Images = ImageList
    Left = 280
    Top = 488
    object mbStart: TMenuItem
      Caption = '&Start'
      object mbConnect: TMenuItem
        Action = ActConnect
      end
      object mbDisconnect: TMenuItem
        Action = ActDisconnect
      end
      object N25: TMenuItem
        Caption = '-'
      end
      object Open1: TMenuItem
        Action = ActOpenFile
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mbExit: TMenuItem
        Action = ActExit
      end
    end
    object mbEdit: TMenuItem
      Caption = '&Edit'
      object mbSetpass: TMenuItem
        Action = ActPassword
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mbNew: TMenuItem
        Caption = '&New'
      end
      object mbEditEntry: TMenuItem
        Action = ActEditEntry
      end
      object Bookmarks1: TMenuItem
        Action = ActBookmark
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object mbCopy: TMenuItem
        Action = ActCopyEntry
      end
      object mbMove: TMenuItem
        Action = ActMoveEntry
      end
      object Createalias1: TMenuItem
        Action = ActAlias
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object mbRename: TMenuItem
        Action = ActRenameEntry
      end
      object mbDeleteEntry: TMenuItem
        Action = ActDeleteEntry
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object mbRefresh: TMenuItem
        Action = ActRefresh
      end
      object Copydntoclipboard1: TMenuItem
        Action = ActCopyDn
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object Locateentry1: TMenuItem
        Action = ActLocateEntry
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mbSearch: TMenuItem
        Action = ActSearch
      end
      object Modifyset1: TMenuItem
        Action = ActModifySet
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mbProperties: TMenuItem
        Action = ActProperties
      end
    end
    object mbView: TMenuItem
      Caption = '&View'
      object mbShowValues: TMenuItem
        Action = ActValues
      end
      object mbShowEntires: TMenuItem
        Action = ActEntries
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object mbViewStyle: TMenuItem
        Caption = '&View Style'
        object mbIconView: TMenuItem
          Action = ActIconView
          Checked = True
          GroupIndex = 1
          RadioItem = True
        end
        object mbSmallView: TMenuItem
          Action = ActSmallView
          GroupIndex = 1
          RadioItem = True
        end
        object mbListView: TMenuItem
          Action = ActListView
          GroupIndex = 1
          RadioItem = True
        end
      end
    end
    object mbTools: TMenuItem
      Caption = '&Tools'
      object mbLanguage: TMenuItem
        Caption = '&Language'
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object mbExport: TMenuItem
        Action = ActExport
      end
      object mbImport: TMenuItem
        Action = ActImport
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object mbSchema: TMenuItem
        Action = ActSchema
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object mbPreferences: TMenuItem
        Action = ActPreferences
      end
      object mbOptions: TMenuItem
        Action = ActOptions
      end
      object Customizemenu1: TMenuItem
        Action = ActCustomizeMenu
      end
      object N24: TMenuItem
        Caption = '-'
      end
      object mbGetTemplates: TMenuItem
        Caption = 'Get templates...'
        OnClick = mbGetTemplatesClick
      end
    end
    object N8: TMenuItem
      Caption = '&?'
      object Help1: TMenuItem
        Action = ActHelp
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object mbInfo: TMenuItem
        Caption = 'Inf&o...'
        OnClick = ActAboutExecute
      end
    end
  end
  object EditPopup: TPopupMenu
    Images = ImageList
    Left = 392
    Top = 488
    object pbChangePassword: TMenuItem
      Action = ActPassword
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object pbNew: TMenuItem
      Caption = '&New'
    end
    object pbEdit: TMenuItem
      Action = ActEditEntry
    end
    object Bookmarks2: TMenuItem
      Action = ActBookmark
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object pbCopy: TMenuItem
      Action = ActCopyEntry
    end
    object pbMove: TMenuItem
      Action = ActMoveEntry
    end
    object mbAlias: TMenuItem
      Action = ActAlias
    end
    object N19: TMenuItem
      Caption = '-'
    end
    object pbRename: TMenuItem
      Action = ActRenameEntry
    end
    object pbDelete: TMenuItem
      Action = ActDeleteEntry
    end
    object N20: TMenuItem
      Caption = '-'
    end
    object pbRefresh: TMenuItem
      Action = ActRefresh
    end
    object Copydntoclipboard2: TMenuItem
      Action = ActCopyDn
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object pbSearch: TMenuItem
      Action = ActSearch
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object pbProperties: TMenuItem
      Action = ActProperties
    end
  end
  object ScrollTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = ScrollTimerTimer
    Left = 32
    Top = 48
  end
  object ActionList: TActionList
    Images = ImageList
    OnUpdate = ActionListUpdate
    Left = 432
    Top = 424
    object ActConnect: TAction
      Category = 'Start'
      Caption = 'Connect...'
      Enabled = False
      Hint = 'Connect'
      ImageIndex = 10
      OnExecute = ActConnectExecute
    end
    object ActDisconnect: TAction
      Category = 'Start'
      Caption = 'Disconnect...'
      Enabled = False
      Hint = 'Disconnect'
      ImageIndex = 11
      OnExecute = ActDisconnectExecute
    end
    object ActExit: TAction
      Category = 'Start'
      Caption = '&Exit'
      Enabled = False
      Hint = 'Exit'
      OnExecute = ActExitExecute
    end
    object ActSchema: TAction
      Category = 'Tools'
      Caption = 'Schema...'
      Enabled = False
      Hint = 'Schema Viewer'
      ImageIndex = 27
      OnExecute = ActSchemaExecute
    end
    object ActImport: TAction
      Category = 'Tools'
      Caption = '&Import...'
      OnExecute = ActImportExecute
    end
    object ActExport: TAction
      Category = 'Tools'
      Caption = '&Export...'
      OnExecute = ActExportExecute
    end
    object ActPreferences: TAction
      Category = 'Tools'
      Caption = 'Session &preferences...'
      OnExecute = ActPreferencesExecute
    end
    object ActAbout: TAction
      Category = 'Help'
      Caption = '&About...'
      OnExecute = ActAboutExecute
    end
    object ActPassword: TAction
      Category = 'Edit'
      Caption = '&Set Password...'
      OnExecute = ActPasswordExecute
      ShortCut = 16464
    end
    object ActEditEntry: TAction
      Category = 'Edit'
      Caption = '&Edit Entry...'
      Enabled = False
      Hint = 'Edit entry'
      ImageIndex = 14
      OnExecute = ActEditEntryExecute
    end
    object ActCopyEntry: TAction
      Category = 'Edit'
      Caption = '&Copy...'
      OnExecute = ActCopyEntryExecute
    end
    object ActMoveEntry: TAction
      Category = 'Edit'
      Caption = '&Move...'
      OnExecute = ActMoveEntryExecute
    end
    object ActDeleteEntry: TAction
      Category = 'Edit'
      Caption = '&Delete'
      Enabled = False
      Hint = 'Delete entry'
      ImageIndex = 12
      OnExecute = ActDeleteEntryExecute
    end
    object ActRefresh: TAction
      Category = 'Edit'
      Caption = '&Refresh'
      Enabled = False
      Hint = 'Refresh'
      ImageIndex = 17
      OnExecute = ActRefreshExecute
      ShortCut = 116
    end
    object ActSearch: TAction
      Category = 'Edit'
      Caption = 'Search...'
      Enabled = False
      Hint = 'Search'
      ImageIndex = 20
      OnExecute = ActSearchExecute
      ShortCut = 16454
    end
    object ActProperties: TAction
      Category = 'Edit'
      Caption = '&Properties...'
      Enabled = False
      Hint = 'Edit properties'
      ImageIndex = 16
      OnExecute = ActPropertiesExecute
    end
    object ActViewBinary: TAction
      Category = 'ViewEdit'
      Caption = '&View binary...'
      OnExecute = ActViewBinaryExecute
    end
    object ActValues: TAction
      Category = 'View'
      Caption = 'Show V&alues'
      Checked = True
      OnExecute = ActValuesExecute
    end
    object ActEntries: TAction
      Category = 'View'
      Caption = 'Show &Entries'
      OnExecute = ActEntriesExecute
    end
    object ActIconView: TAction
      Category = 'View'
      Caption = '&Icons'
      OnExecute = ActIconViewExecute
    end
    object ActListView: TAction
      Category = 'View'
      Caption = '&List'
      OnExecute = ActListViewExecute
    end
    object ActSmallView: TAction
      Category = 'View'
      Caption = '&Small Icons'
      OnExecute = ActSmallViewExecute
    end
    object ActOptions: TAction
      Category = 'Tools'
      Caption = '&Options...'
      OnExecute = ActOptionsExecute
    end
    object ActLocateEntry: TAction
      Category = 'Edit'
      Caption = '&Locate entry (Quick Search)...'
      OnExecute = ActLocateEntryExecute
      ShortCut = 114
    end
    object ActCopyDn: TAction
      Category = 'Edit'
      Caption = 'Copy &dn to clipboard'
      OnExecute = ActCopyDnExecute
      ShortCut = 16462
    end
    object ViewEdit: TAction
    end
    object ActCopy: TAction
      Category = 'ViewEdit'
      Caption = 'Copy'
      ImageIndex = 34
      OnExecute = ActCopyExecute
    end
    object ActCopyValue: TAction
      Category = 'ViewEdit'
      Caption = 'Copy Value'
      OnExecute = ActCopyValueExecute
    end
    object ActCopyName: TAction
      Category = 'ViewEdit'
      Caption = 'Copy Attribute name'
      OnExecute = ActCopyNameExecute
    end
    object ActRenameEntry: TAction
      Category = 'Edit'
      Caption = '&Rename...'
      OnExecute = ActRenameEntryExecute
      ShortCut = 113
    end
    object ActFindInSchema: TAction
      Category = 'View'
      Caption = '&Find in schema...'
      OnExecute = ActFindInSchemaExecute
    end
    object ActModifySet: TAction
      Category = 'Edit'
      Caption = '&Modify set...'
      Enabled = False
      Hint = 'Modify attribute values on multiple objects'
      ImageIndex = 38
      OnExecute = ActModifySetExecute
    end
    object ActEditValue: TAction
      Category = 'ViewEdit'
      Caption = 'Edit value...'
      Enabled = False
      OnExecute = ActEditValueExecute
    end
    object ActAlias: TAction
      Category = 'Edit'
      Caption = 'Create &alias...'
      ImageIndex = 44
      OnExecute = ActAliasExecute
    end
    object ActCustomizeMenu: TAction
      Category = 'Tools'
      Caption = '&Customize menu...'
      OnExecute = ActCustomizeMenuExecute
    end
    object ActGoTo: TAction
      Category = 'ViewEdit'
      Caption = '&Go to...'
      ImageIndex = 30
      OnExecute = ActGoToExecute
    end
    object ActBookmark: TAction
      Category = 'Edit'
      Caption = 'Bookmarks...'
      Enabled = False
      ImageIndex = 49
      OnExecute = ActBookmarkExecute
      ShortCut = 16450
    end
    object ActHelp: TAction
      Category = 'Help'
      Caption = '&Help...'
      OnExecute = ActHelpExecute
      ShortCut = 112
    end
    object ActOpenFile: TAction
      Category = 'Start'
      Caption = 'Open...'
      ImageIndex = 48
      OnExecute = ActOpenFileExecute
    end
  end
  object ListPopup: TPopupMenu
    Images = ImageList
    AutoPopup = False
    OnPopup = ListPopupPopup
    Left = 504
    Top = 488
    object pbEditValue: TMenuItem
      Action = ActEditValue
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object pbViewCopy: TMenuItem
      Action = ActCopy
    end
    object pbViewCopyName: TMenuItem
      Action = ActCopyName
    end
    object pbViewCopyValue: TMenuItem
      Action = ActCopyValue
    end
    object N23: TMenuItem
      Caption = '-'
    end
    object Goto1: TMenuItem
      Action = ActGoTo
    end
    object pbFindInSchema: TMenuItem
      Action = ActFindInSchema
    end
    object N18: TMenuItem
      Caption = '-'
    end
    object pbViewBinary: TMenuItem
      Action = ActViewBinary
    end
    object pbViewCert: TMenuItem
      Caption = 'View &certificate...'
      OnClick = pbViewCertClick
    end
    object pbViewPicture: TMenuItem
      Caption = 'View &picture...'
      OnClick = pbViewPictureClick
    end
  end
  object OpenFile: TOpenDialog
    DefaultExt = '.ldif'
    Filter = 'Ldif Files (*.ldif)|*.ldif|All Files (*.*)|*.*'
    Left = 552
    Top = 424
  end
end
