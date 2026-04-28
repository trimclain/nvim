-- Icons used everywhere in the config
-- More: https://www.nerdfonts.com/cheat-sheet

local M = {}

M.actions = {
    CloseThick = "",
    Cancel = "󰜺", -- ""; referenced
    Check = "", -- ""; referenced
    Close = "",
    CloudDownload = "", -- ""
    DoubleCheck = "", -- referenced
    FindText = "󰊄",
    Pause = "", -- referenced
    Pencil = "",
    Plus = "",
    Search = "", -- ""; referenced
    SignIn = "", -- ""
    SignOut = "", -- ""; referenced
}

M.diagnostics = {
    Debug = "",
    Error = "", -- referenced
    ErrorThick = "",
    Hint = "󰌶", -- ""; referenced
    HintThick = "",
    Info = "", -- referenced
    InfoThick = "",
    QuestionThick = "",
    Trace = "✎",
    Warn = "", -- referenced
    WarnThick = "", -- referenced
}

M.files = {
    EmptyFolder = "",
    EmptyFolderOpen = "",
    FileSymlink = "",
    Files = "", -- referenced
    FindFile = "󰈞",
    FolderOpen = "", -- ""
    FolderSymlink = "",
    GitFolder = "", -- referenced
    NewFile = "", -- ""; referenced
    Note = "",
    Notebook = "",
    Project = "", -- ""
}

M.git = {
    Added = "", -- ""; referenced
    Modified = "", -- ""; referenced
    Removed = "", -- ""; referenced
    Ignored = "", -- "", "◌"; referenced
    Renamed = "", -- referenced
    Merged = "", -- ""; -- referenced
    Diff = "", -- ""
    Branch = "", -- "", "" "", "󰘬" -- referenced
    Repo = "",
}

M.keyboard = {
    C = "󰘴",
    M = "󰘵",
    D = "󰘳",
    S = "󰘶",
    CR = "󰌑",
    Esc = "󱊷",
    ScrollWheelDown = "󱕐",
    ScrollWheelUp = "󱕑",
    BS = "󰁮",
    Space = "󱁐",
    Tab = "󰌒", -- referenced
    F1 = "󱊫",
    F2 = "󱊬",
    F3 = "󱊭",
    F4 = "󱊮",
    F5 = "󱊯",
    F6 = "󱊰",
    F7 = "󱊱",
    F8 = "󱊲",
    F9 = "󱊳",
    F10 = "󱊴",
    F11 = "󱊵",
    F12 = "󱊶",
}

--- LSP symbol kinds
M.kinds = { -- referenced
    Text = "󰊄", -- "", ""; 1
    Method = "󰊕", -- ""; 2
    Function = "󰊕", -- ""; 3
    Constructor = "", -- "", ""; 4
    Field = "󰜢", -- ""; 5
    Variable = "󰀫", -- ""; 6
    Class = "", -- 7
    Interface = "", -- ""; 8
    Module = "", -- 9
    Property = "", -- ""; 10
    Unit = "", -- ""; 11
    Value = "󰎠", -- ""; 12
    Enum = "", -- ""; 13
    Keyword = "󰌋", -- ""; 14
    Snippet = "", -- "", ""; 15
    Color = "", -- 16
    File = "", -- ""; 17
    Reference = "", -- ""; 18
    Folder = "", -- ""; 19
    EnumMember = "", -- ""; 20
    Constant = "", -- "", "󰏿"; 21
    Struct = "", -- ""; 22
    Event = "", -- ""; 23
    Operator = "󱓉", -- ""; 24
    TypeParameter = "", -- 25
}

M.layout = {
    BigCircle = "", -- name: nf-cod-circle_large_filled
    BigUnfilledCircle = "", -- name: nf-cod-circle_large
    Circle = "●", -- referenced
    DashedLine = "┊", -- referenced
    DividerLeft = "",
    DividerLeftThick = "",
    DividerRight = "",
    DividerRightThick = "",
    Dot = "",
    Ellipsis = "",
    LineCorner = "└", -- referenced
    LineLeft = "▏", -- referenced
    LineLeftThick = "▎", -- referenced
    LineMiddle = "│", -- referenced
    MidCircle = "", -- name: nf-fa-circle
    MidDottedCircle = "", -- name: nf-fa-circle_dot
    MidUnfilledCircle = "", -- name: nf-oct-circle
    Triangle = "󰐊",
}

M.misc = {
    Copilot = "", -- referenced
    Misc = "",
    Robot = "",
    Squirrel = "", -- ""
    Tag = "", -- ""
    Tree = "",
    Vim = "", -- referenced
    Watch = "",
    Watches = "󰂥",
}

M.nav = {
    ArrowCircleDown = "",
    ArrowCircleLeft = "",
    ArrowCircleRight = "",
    ArrowCircleUp = "",
    ArrowClosed = "", -- ""; referenced
    ArrowClosedSmall = "", -- referenced
    ArrowDownThick = "",
    ArrowLeftThick = "",
    ArrowOpen = "", -- ""; referenced
    ArrowOpenSmall = "", -- referenced
    ArrowRightThick = "", -- "󰁕"
    ArrowUpThick = "",
    ChevronDown = "",
    ChevronRight = "",
    ChevronShortDown = "",
    ChevronShortLeft = "",
    ChevronShortRight = "",
    ChevronShortUp = "",
    DoubleChevronRight = "»",
    Forward = "",
    TriangleShortArrowDown = "",
    TriangleShortArrowLeft = "",
    TriangleShortArrowRight = "",
    TriangleShortArrowUp = "",
}

M.status = {
    Bookmark = "", -- ""
    BoxChecked = "󰄵", -- "", "󰱒"; referenced
    BoxUnchecked = "󰄱", -- referenced
    Bug = "", -- ""; referenced
    Calendar = "", -- ""
    Clock = "", -- "", "󰥔"; referenced
    Fire = "", -- ""; referenced
    History = "",
    Lazy = "󰒲", -- referenced
    Lightbulb = "",
    Lock = "", -- referenced
    Message = "󰍩", --referenced
    Question = "", -- ""; referenced
    Speedometer = "󰾆", -- "⏲"; referenced
    Target = "󰀘",
}

M.tools = {
    Code = "", -- ""
    Comment = "",
    Dashboard = "", -- ""
    DebugConsole = "",
    Gear = "", -- ""; referenced
    List = "", -- ""; referenced
    Paragraph = "󰊆",
    Scopes = "",
    Stacks = "",
    Table = "", -- ""
    Telescope = "", -- ""
}

M.types = {
    Array = "",
    Boolean = "",
    Key = "",
    Namespace = "",
    Null = "󰟢", -- ""
    Number = "",
    Object = "",
    Package = "", -- ""
    String = "", -- ""
}

M.unicode = {
    Add = "✚",
    ArrowRightThick = "➜",
    BallotX = "✗", -- referenced
    Check = "✓", -- referenced
    GappedCircleArrowClockwise = "⟳",
    MultiplicationX = "✖",
    OpenCircleArrowAnticlockwise = "↺", -- referenced
    OpenCircleArrowClockwise = "↻", -- referenced
    Warn = "⚠",
}

return M
